import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/widgets/fields/dropdown_search.dart';
import 'package:wasslni_plus/widgets/fields/editable_field.dart';
import 'package:wasslni_plus/widgets/fields/read_only_field.dart';
import 'package:wasslni_plus/flow/common/barcode_scanner_page.dart';

class AddParcelPage extends StatefulWidget {
  final ParcelModel? parcel;
  const AddParcelPage({super.key, this.parcel});

  @override
  State<AddParcelPage> createState() => _AddParcelPageState();
}

class _AddParcelPageState extends State<AddParcelPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;

  String? selectedRegion;
  final Map<String, int> regionPrices = {
    'الداخل': 70,
    'القدس': 30,
    'الضفة': 20,
  };

  String? barcode;
  int? finalTotal;
  bool _regionHasError = false;
  String _phoneCountryCode = '+972';
  String _altPhoneCountryCode = '+972';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _parcelPriceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _parcelPriceController.addListener(_updateTotalPrice);

    if (widget.parcel != null) {
      _initializeEditMode();
    }
  }

  void _initializeEditMode() {
    final parcel = widget.parcel!;
    _nameController.text = parcel.recipientName;

    // Extract country code from phone number and add leading 0
    if (parcel.recipientPhone.startsWith('+972')) {
      _phoneCountryCode = '+972';
      final phoneWithoutCode = parcel.recipientPhone.substring(4);
      // Add leading 0 if not present
      _phoneController.text = phoneWithoutCode.startsWith('0')
          ? phoneWithoutCode
          : '0$phoneWithoutCode';
    } else if (parcel.recipientPhone.startsWith('+970')) {
      _phoneCountryCode = '+970';
      final phoneWithoutCode = parcel.recipientPhone.substring(4);
      // Add leading 0 if not present
      _phoneController.text = phoneWithoutCode.startsWith('0')
          ? phoneWithoutCode
          : '0$phoneWithoutCode';
    } else {
      _phoneController.text = parcel.recipientPhone;
    }

    // Extract country code from alt phone number and add leading 0
    if (parcel.recipientAltPhone != null) {
      if (parcel.recipientAltPhone!.startsWith('+972')) {
        _altPhoneCountryCode = '+972';
        final phoneWithoutCode = parcel.recipientAltPhone!.substring(4);
        // Add leading 0 if not present
        _altPhoneController.text = phoneWithoutCode.startsWith('0')
            ? phoneWithoutCode
            : '0$phoneWithoutCode';
      } else if (parcel.recipientAltPhone!.startsWith('+970')) {
        _altPhoneCountryCode = '+970';
        final phoneWithoutCode = parcel.recipientAltPhone!.substring(4);
        // Add leading 0 if not present
        _altPhoneController.text = phoneWithoutCode.startsWith('0')
            ? phoneWithoutCode
            : '0$phoneWithoutCode';
      } else {
        _altPhoneController.text = parcel.recipientAltPhone ?? '';
      }
    }
    _descController.text = parcel.description ?? '';
    _parcelPriceController.text = parcel.parcelPrice.toInt().toString();
    _addressController.text = parcel.deliveryAddress;
    selectedRegion = parcel.deliveryRegion;
    barcode = parcel.barcode;
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    final parcelPrice = int.tryParse(_parcelPriceController.text) ?? 0;
    final deliveryFee =
        selectedRegion != null ? regionPrices[selectedRegion]! : 0;
    setState(() {
      finalTotal = parcelPrice + deliveryFee;
    });
  }

  @override
  void dispose() {
    _parcelPriceController.removeListener(_updateTotalPrice);
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _descController.dispose();
    _parcelPriceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    setState(() {
      _regionHasError = selectedRegion == null;
    });

    if (!_formKey.currentState!.validate() || selectedRegion == null) {
      if (selectedRegion == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).choose_region_warning)),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final parcelPrice = double.parse(_parcelPriceController.text);
      final deliveryFee = regionPrices[selectedRegion]!.toDouble();

      // Use barcode if provided, otherwise generate one
      final parcelBarcode =
          barcode ?? await _firestoreService.generateUniqueBarcode();

      // Remove leading 0 from phone numbers before saving
      String formatPhoneNumber(String phone) {
        return phone.startsWith('0') ? phone.substring(1) : phone;
      }

      final parcelData = ParcelModel(
        id: widget.parcel?.id,
        barcode: parcelBarcode,
        merchantId: user.uid,
        recipientName: _nameController.text,
        recipientPhone:
            _phoneCountryCode + formatPhoneNumber(_phoneController.text),
        recipientAltPhone: _altPhoneController.text.isNotEmpty
            ? _altPhoneCountryCode + formatPhoneNumber(_altPhoneController.text)
            : null,
        deliveryAddress: _addressController.text,
        deliveryRegion: selectedRegion!,
        description:
            _descController.text.isNotEmpty ? _descController.text : null,
        parcelPrice: parcelPrice,
        deliveryFee: deliveryFee,
        totalPrice: parcelPrice + deliveryFee,
        createdAt: widget.parcel?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        status: widget.parcel?.status ?? ParcelStatus.awaitingLabel,
      );

      if (widget.parcel != null) {
        // Update existing parcel
        await _firestoreService.updateParcel(
          widget.parcel!.id!,
          parcelData.toMap(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).parcel_updated_success)),
          );
        }
      } else {
        // Create new parcel
        await _firestoreService.createParcel(parcelData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).parcel_created_success)),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error submitting parcel: $e'); // Debug log
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).error_occurred(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final isEdit = widget.parcel != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? tr.edit_parcel : tr.add_parcel),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: AppStyles.defaultPadding,
                child: ListView(
                  children: [
                    EditableField(
                      label: tr.recipient_name,
                      controller: _nameController,
                      isEditMode: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return tr.enter_recipient_name;
                        }
                        return null;
                      },
                    ),
                    // Phone number with country code dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 16),
                          child: Text(
                            tr.recipient_phone,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _phoneCountryCode,
                                underline: const SizedBox(),
                                items: ['+972', '+970'].map((code) {
                                  return DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _phoneCountryCode = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0521234567',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return tr.enter_phone;
                                  }
                                  // Must be 10 digits starting with 05
                                  if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
                                    return 'Phone must be 10 digits starting with 05';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Alternate phone number with country code dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 16),
                          child: Text(
                            tr.alt_phone,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _altPhoneCountryCode,
                                underline: const SizedBox(),
                                items: ['+972', '+970'].map((code) {
                                  return DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _altPhoneCountryCode = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _altPhoneController,
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0521234567',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownSerach(
                      labelText: tr.region,
                      selectedValue: selectedRegion,
                      isEditMode: true,
                      items: regionPrices.keys.toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
                        _updateTotalPrice();
                      },
                      displaySearch: true,
                      onClear: () {
                        setState(() {
                          selectedRegion = null;
                        });
                        _updateTotalPrice();
                      },
                    ),
                    if (_regionHasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 12),
                        child: Text(
                          tr.choose_region_warning,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    EditableField(
                      label: tr.address,
                      controller: _addressController,
                      isEditMode: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr.enter_address;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    EditableField(
                      label: tr.parcel_price,
                      controller: _parcelPriceController,
                      isEditMode: true,
                      forceLTR: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr.enter_price;
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 0) {
                          return tr.invalid_price;
                        }
                        return null;
                      },
                    ),
                    EditableField(
                      label: tr.parcel_description,
                      controller: _descController,
                      isEditMode: true,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final scannedBarcode = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BarcodeScannerPage(),
                          ),
                        );

                        if (scannedBarcode != null) {
                          setState(() {
                            barcode = scannedBarcode;
                          });
                        }
                      },
                      icon: const Icon(Icons.qr_code_scanner_outlined),
                      label: Text(tr.attach_barcode),
                    ),
                    if (barcode != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(tr.barcode_label(barcode!),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                            )),
                      ),
                    if (finalTotal != null)
                      ReadOnlyField(
                        label: tr.total_price_label,
                        value: '$finalTotal ₪',
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        isEdit ? tr.update_parcel : tr.save_parcel,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (isEdit) ...[
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _cancelParcel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          tr.cancel_parcel,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _cancelParcel() async {
    final reasonController = TextEditingController();
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).cancel_parcel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).confirm_cancel_parcel),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: S.of(context).cancellation_reason,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.of(context).yes_cancel),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('User not logged in');

        await _firestoreService.updateParcelStatus(
          widget.parcel!.id!,
          ParcelStatus.cancelled,
          user.uid, // Using UID as updatedBy for now, ideally should be name
          notes: reasonController.text,
        );

        // Also update the failureReason field for easier access
        await _firestoreService.updateParcel(
          widget.parcel!.id!,
          {'failureReason': reasonController.text},
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).parcel_cancelled_success)),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).error_occurred(e.toString()))),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
