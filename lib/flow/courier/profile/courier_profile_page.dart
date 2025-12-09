import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/region_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/widgets/log_in.dart';
import 'package:provider/provider.dart';
import 'package:wasslni_plus/provider/app_settings_providor.dart';

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
  bool _isInitialLoading = true;
  String? _selectedLanguage;
  UserModel? _userData;
  String? _errorMessage;
  List<RegionModel>? _regions; // Cache regions data

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _vehiclePlateController = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleTypeController.dispose();
    _vehiclePlateController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = _authService.currentUser;
    if (user == null) {
      setState(() {
        _isInitialLoading = false;
        _errorMessage = 'No user logged in';
      });
      return;
    }

    try {
      // Load both user data and regions in parallel for efficiency
      final results = await Future.wait([
        _firestoreService.getUser(user.uid),
        _firestoreService.getAllRegions(),
      ]);

      final userData = results[0] as UserModel?;
      final regions = results[1] as List<RegionModel>;

      if (userData != null) {
        setState(() {
          _userData = userData;
          _regions = regions;
          _nameController.text = userData.name;
          _vehicleTypeController.text = userData.vehicleType ?? '';
          _vehiclePlateController.text = userData.vehiclePlate ?? '';
          _availability = userData.availability ?? false;
          _selectedRegions = List.from(userData.workingRegions ?? []);
          _selectedLanguage ??=
              Provider.of<AppSettingsProvidor>(context, listen: false)
                  .locale
                  .languageCode;
          _isInitialLoading = false;
        });
      } else {
        setState(() {
          _isInitialLoading = false;
          _errorMessage = 'No user data found';
        });
      }
    } catch (e) {
      setState(() {
        _isInitialLoading = false;
        _errorMessage = e.toString();
      });
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
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _userData == null
                  ? _buildNoDataView(user.uid)
                  : _buildProfileForm(tr, user.uid),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isInitialLoading = true;
                  _errorMessage = null;
                });
                _loadData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataView(String uid) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No user data found',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text('User ID: $uid'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout & Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(S tr, String uid) {
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
                _updateAvailability(uid, value);
              },
            ),
            const Divider(height: 32),

            // Language Selection
            Text(
              tr.language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyles.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('العربية'),
                    value: 'ar',
                    groupValue: _selectedLanguage,
                    activeColor: AppStyles.primaryColor,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('English'),
                    value: 'en',
                    groupValue: _selectedLanguage,
                    activeColor: AppStyles.primaryColor,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }
                    },
                  ),
                ),
              ],
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

            // Render regions from cached data (no database queries on interaction!)
            _buildRegionsSection(tr),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _saveChanges(uid, tr),
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
  }

  Widget _buildRegionsSection(S tr) {
    if (_regions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_regions!.isEmpty) {
      return Card(
        color: Colors.orange.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.location_off, color: Colors.orange, size: 40),
              const SizedBox(height: 8),
              const Text(
                'No delivery regions available',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await _firestoreService.initializeDefaultRegions();
                    if (mounted) {
                      // Reload regions after initialization
                      final regions = await _firestoreService.getAllRegions();
                      setState(() {
                        _regions = regions;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Regions initialized successfully!')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Initialize Regions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: _regions!.map((region) {
        final isSelected = _selectedRegions.contains(region.nameEn);
        return FilterChip(
          label: Text(
            Localizations.localeOf(context).languageCode == 'ar'
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
      final updates = {
        'vehicleType': _vehicleTypeController.text.trim(),
        'vehiclePlate': _vehiclePlateController.text.trim(),
        'workingRegions': _selectedRegions,
        'availability': _availability,
      };

      // Add language preference if changed
      if (_selectedLanguage != null) {
        updates['preferredLanguage'] = _selectedLanguage!;
      }

      await _firestoreService.updateUser(uid, updates);

      // Apply language change if it was modified
      if (_selectedLanguage != null && mounted) {
        final settings =
            Provider.of<AppSettingsProvidor>(context, listen: false);
        if (_selectedLanguage != settings.locale.languageCode) {
          settings.changeLanguage(Locale(_selectedLanguage!));
        }
      }

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
