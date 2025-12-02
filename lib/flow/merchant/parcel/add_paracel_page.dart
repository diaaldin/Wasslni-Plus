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
    _phoneController.text = parcel.recipientPhone;
    _altPhoneController.text = parcel.recipientAltPhone ?? '';
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

      // Generate barcode if not exists
      final parcelBarcode =
          barcode ?? await _firestoreService.generateUniqueBarcode();

      final parcelData = ParcelModel(
        id: widget.parcel?.id,
        barcode: parcelBarcode,
        merchantId: user.uid,
        recipientName: _nameController.text,
        recipientPhone: _phoneController.text,
        recipientAltPhone: _altPhoneController.text.isNotEmpty
            ? _altPhoneController.text
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
            const SnackBar(content: Text('Parcel updated successfully')),
          );
        }
      } else {
        // Create new parcel
        await _firestoreService.createParcel(parcelData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Parcel created successfully')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
        title: Text(isEdit ? 'Edit Parcel' : tr.add_parcel),
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
                    EditableField(
                      label: tr.recipient_phone,
                      controller: _phoneController,
                      isEditMode: true,
                      forceLTR: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return tr.enter_phone;
                        }
                        if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
                          return tr.invalid_phone;
                        }
                        return null;
                      },
                    ),
                    EditableField(
                      label: tr.alt_phone,
                      controller: _altPhoneController,
                      isEditMode: true,
                      forceLTR: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
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
                      onPressed: () {
                        // TODO: barcode scanning
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
                        isEdit ? 'Update Parcel' : tr.save_parcel,
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
                        child: const Text(
                          'Cancel Parcel',
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
        title: const Text('Cancel Parcel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this parcel?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Cancellation Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
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
            const SnackBar(content: Text('Parcel cancelled successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
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
