import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/region_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/widgets/log_in.dart';

class CourierProfilePage extends StatefulWidget {
  const CourierProfilePage({super.key});

  @override
  State<CourierProfilePage> createState() => _CourierProfilePageState();
}

class _CourierProfilePageState extends State<CourierProfilePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehiclePlateController;
  bool _availability = false;
  List<String> _selectedRegions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _vehiclePlateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleTypeController.dispose();
    _vehiclePlateController.dispose();
    super.dispose();
  }

  void _initializeData(UserModel user) {
    if (_nameController.text.isEmpty) {
      _nameController.text = user.name;
      _vehicleTypeController.text = user.vehicleType ?? '';
      _vehiclePlateController.text = user.vehiclePlate ?? '';
      _availability = user.availability ?? false;
      _selectedRegions = List.from(user.workingRegions ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.settings),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, tr),
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: _firestoreService.streamUser(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(tr.error_loading_data));
          }

          final userData = snapshot.data!;
          _initializeData(userData);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Availability Toggle
                  SwitchListTile(
                    title: Text(
                      tr.availability,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _availability ? tr.online : tr.offline,
                      style: TextStyle(
                        color: _availability ? Colors.green : Colors.grey,
                      ),
                    ),
                    value: _availability,
                    activeThumbColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _availability = value;
                      });
                      _updateAvailability(user.uid, value);
                    },
                  ),
                  const Divider(height: 32),

                  Text(
                    tr.vehicle_info,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _vehicleTypeController,
                    decoration: InputDecoration(
                      labelText: tr.vehicle_type,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.directions_car),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr.validation_required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _vehiclePlateController,
                    decoration: InputDecoration(
                      labelText: tr.vehicle_plate,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.confirmation_number),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr.validation_required;
                      }
                      return null;
                    },
                  ),
                  const Divider(height: 32),

                  Text(
                    tr.working_regions,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  FutureBuilder<List<RegionModel>>(
                    future: _firestoreService.getAllRegions(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final regions = snapshot.data!;
                      return Wrap(
                        spacing: 8,
                        children: regions.map((region) {
                          final isSelected =
                              _selectedRegions.contains(region.nameEn);
                          return FilterChip(
                            label: Text(
                              // Display localized name if possible, for now simple logic
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? region.nameAr
                                  : region.nameEn,
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedRegions.add(region.nameEn);
                                } else {
                                  _selectedRegions.remove(region.nameEn);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _saveChanges(user.uid, tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(tr.save_changes),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateAvailability(String uid, bool isAvailable) async {
    try {
      await _firestoreService.updateUser(uid, {'availability': isAvailable});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating availability: $e')),
        );
        setState(() {
          _availability = !isAvailable; // Revert on error
        });
      }
    }
  }

  Future<void> _saveChanges(String uid, S tr) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _firestoreService.updateUser(uid, {
        'vehicleType': _vehicleTypeController.text.trim(),
        'vehiclePlate': _vehiclePlateController.text.trim(),
        'workingRegions': _selectedRegions,
        'availability': _availability,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.profile_updated_success)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.error_occurred(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmLogout(BuildContext context, S tr) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.logout),
        content: Text(tr.logout_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await _authService.signOut();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr.logout_error)),
          );
        }
      }
    }
  }
}
