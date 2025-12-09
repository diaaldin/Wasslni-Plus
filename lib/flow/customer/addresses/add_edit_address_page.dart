import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/address_model.dart';
import 'package:wasslni_plus/models/region_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class AddEditAddressPage extends StatefulWidget {
  final AddressModel? address; // null for add, not null for edit

  const AddEditAddressPage({super.key, this.address});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _labelController;
  late TextEditingController _recipientNameController;
  late TextEditingController _recipientPhoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;

  String? _selectedRegion;
  bool _isDefault = false;
  bool _isLoading = false;
  List<RegionModel> _regions = [];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.address?.label ?? '');
    _recipientNameController =
        TextEditingController(text: widget.address?.recipientName ?? '');
    _recipientPhoneController =
        TextEditingController(text: widget.address?.recipientPhone ?? '');
    _addressController =
        TextEditingController(text: widget.address?.address ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _selectedRegion = widget.address?.region;
    _isDefault = widget.address?.isDefault ?? false;
    _loadRegions();
  }

  Future<void> _loadRegions() async {
    try {
      final regions = await _firestoreService.getAllRegions();
      setState(() {
        _regions = regions;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading regions: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final isEditing = widget.address != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? tr.edit_address : tr.add_address),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Label field
            TextFormField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: tr.address_label,
                hintText: tr.address_label_hint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr.validation_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Quick label buttons
            Wrap(
              spacing: 8,
              children: [
                _buildQuickLabelChip(tr.home, Icons.home),
                _buildQuickLabelChip(tr.work, Icons.work),
                _buildQuickLabelChip(tr.other, Icons.place),
              ],
            ),
            const SizedBox(height: 24),

            // Recipient name
            TextFormField(
              controller: _recipientNameController,
              decoration: InputDecoration(
                labelText: tr.recipient_name,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr.validation_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Recipient phone
            TextFormField(
              controller: _recipientPhoneController,
              decoration: InputDecoration(
                labelText: tr.recipient_phone,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr.validation_required;
                }
                if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                  return tr.invalid_phone;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: tr.address,
                hintText: tr.address_hint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr.validation_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // City
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: tr.city,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr.validation_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Region dropdown
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: InputDecoration(
                labelText: tr.region,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.map),
              ),
              items: _regions.map((region) {
                return DropdownMenuItem<String>(
                  value: region.nameEn,
                  child: Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? region.nameAr
                        : region.nameEn,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRegion = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr.validation_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Set as default checkbox
            CheckboxListTile(
              title: Text(tr.set_as_default),
              subtitle: Text(tr.set_as_default_hint),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              activeColor: AppStyles.primaryColor,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEditing ? tr.update_address : tr.save_address,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),

            if (isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _confirmDelete(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.delete),
                label: Text(tr.delete_address),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLabelChip(String label, IconData icon) {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onPressed: () {
        setState(() {
          _labelController.text = label;
        });
      },
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final address = AddressModel(
        id: widget.address?.id,
        userId: user.uid,
        label: _labelController.text.trim(),
        recipientName: _recipientNameController.text.trim(),
        recipientPhone: _recipientPhoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        region: _selectedRegion!,
        isDefault: _isDefault,
        createdAt: widget.address?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.address == null) {
        // Create new address
        await _firestoreService.createAddress(address);
      } else {
        // Update existing address
        await _firestoreService.updateAddress(address.id!, address.toMap());
      }

      // If set as default, update the default address
      if (_isDefault && address.id != null) {
        await _firestoreService.setDefaultAddress(user.uid, address.id!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.address == null
                  ? S.of(context).address_added_success
                  : S.of(context).address_updated_success,
            ),
          ),
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

  Future<void> _confirmDelete() async {
    final tr = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.delete_address),
        content: Text(tr.delete_address_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      try {
        await _firestoreService.deleteAddress(widget.address!.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr.address_deleted)),
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
