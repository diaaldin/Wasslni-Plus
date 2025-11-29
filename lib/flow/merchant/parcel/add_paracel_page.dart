import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/generated/l10n.dart';
import 'package:turoudi/widgets/fields/dropdown_search.dart';
import 'package:turoudi/widgets/fields/editable_field.dart';
import 'package:turoudi/widgets/fields/read_only_field.dart';

class AddParcelPage extends StatefulWidget {
  const AddParcelPage({super.key});

  @override
  State<AddParcelPage> createState() => _AddParcelPageState();
}

class _AddParcelPageState extends State<AddParcelPage> {
  final _formKey = GlobalKey<FormState>();

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

  void _updateTotalPrice() {
    final parcelPrice = int.tryParse(_parcelPriceController.text) ?? 0;
    final deliveryFee =
        selectedRegion != null ? regionPrices[selectedRegion]! : 0;
    setState(() {
      finalTotal = parcelPrice + deliveryFee;
    });
  }

  @override
  void initState() {
    super.initState();
    _parcelPriceController.addListener(_updateTotalPrice);
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

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.add_parcel),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Form(
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
                  if (!RegExp(r'^\d{7,15}\$').hasMatch(value)) {
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
                    style: const TextStyle(color: Colors.red, fontSize: 12),
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
                        color: Theme.of(context).textTheme.labelLarge?.color,
                      )),
                ),
              if (finalTotal != null)
                ReadOnlyField(
                  label: tr.total_price_label,
                  value: '$finalTotal ₪',
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _regionHasError = selectedRegion == null;
                  });

                  if (_formKey.currentState!.validate() ||
                      selectedRegion == null) {
                    if (selectedRegion == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr.choose_region_warning)),
                      );

                      return;
                    }
                    // TODO: handle submission
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    Text(tr.save_parcel, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
