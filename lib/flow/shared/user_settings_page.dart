import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/widgets/log_in.dart';
import 'package:wasslni_plus/flow/shared/notification_preferences_page.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userData = await _firestoreService.getUser(user.uid);
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.settings),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? Center(child: Text(tr.error_loading_data))
              : ListView(
                  children: [
                    // Profile Section
                    _buildSectionHeader(tr.profile, Icons.person),
                    _buildProfileTile(tr, _userData!),
                    _buildDivider(),

                    // Account Section
                    _buildSectionHeader(tr.account, Icons.manage_accounts),
                    _buildSettingTile(
                      icon: Icons.edit,
                      title: tr.edit_profile,
                      subtitle: tr.update_your_information,
                      onTap: () => _showEditProfileDialog(),
                    ),
                    _buildSettingTile(
                      icon: Icons.lock,
                      title: tr.change_password,
                      subtitle: tr.update_password_security,
                      onTap: () => _showChangePasswordDialog(),
                    ),
                    _buildDivider(),

                    // Notifications Section
                    _buildSectionHeader(tr.notifications, Icons.notifications),
                    _buildSettingTile(
                      icon: Icons.notification_important,
                      title: tr.notification_settings,
                      subtitle: tr.manage_notification_preferences,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationPreferencesPage(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),

                    // Danger Zone
                    _buildSectionHeader(tr.danger_zone, Icons.warning,
                        color: Colors.red),
                    _buildSettingTile(
                      icon: Icons.delete_forever,
                      title: tr.delete_account,
                      subtitle: tr.permanently_delete_account,
                      onTap: () => _showDeleteAccountDialog(),
                      titleColor: Colors.red,
                    ),
                    _buildDivider(),

                    // Logout
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmLogout(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.logout),
                        label: Text(tr.logout),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? AppStyles.primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? AppStyles.primaryColor,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(S tr, UserModel user) {
    final contactInfo = (user.email != null && user.email!.isNotEmpty)
        ? user.email!
        : user.phoneNumber;

    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: AppStyles.primaryColor.withAlpha(50),
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyles.primaryColor,
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(contactInfo),
          const SizedBox(height: 2),
          Text(
            _getRoleDisplayName(user.role, tr),
            style: const TextStyle(
              color: AppStyles.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(user.status).withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _getStatusDisplayName(user.status, tr),
          style: TextStyle(
            color: _getStatusColor(user.status),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }

  String _getRoleDisplayName(UserRole role, S tr) {
    switch (role) {
      case UserRole.merchant:
        return tr.merchant;
      case UserRole.courier:
        return tr.courier;
      case UserRole.customer:
        return tr.customer;
      case UserRole.admin:
        return tr.admin;
      case UserRole.manager:
        return tr.manager;
    }
  }

  String _getStatusDisplayName(UserStatus status, S tr) {
    switch (status) {
      case UserStatus.active:
        return tr.active;
      case UserStatus.inactive:
        return tr.inactive;
      case UserStatus.suspended:
        return tr.suspended;
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.inactive:
        return Colors.orange;
      case UserStatus.suspended:
        return Colors.red;
    }
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userData!.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final tr = S.of(context);
        return AlertDialog(
          title: Text(tr.edit_profile),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: tr.name,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await _firestoreService.updateUser(
                      _userData!.uid!,
                      {'name': nameController.text.trim()},
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profile updated successfully')),
                      );
                      await _loadUserData();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
              ),
              child: Text(tr.save_changes),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final tr = S.of(context);
        return AlertDialog(
          title: Text(tr.change_password),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: tr.current_password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr.validation_required;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: tr.new_password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr.validation_required;
                    }
                    if (value.length < 6) {
                      return tr.password_too_short;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: tr.confirm_password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return tr.passwords_dont_match;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await _authService.changePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr.password_changed_success)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(tr.password_change_failed(e.toString()))),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
              ),
              child: Text(tr.change_password),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    final tr = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(tr.delete_account),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.delete_account_warning,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(tr.delete_account_consequences),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestoreService.updateUser(
                  _userData!.uid!,
                  {'status': UserStatus.inactive.name, 'isDeleted': true},
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  await _authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(tr.delete_account),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final tr = S.of(context);
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

    if (confirmed == true && mounted) {
      try {
        await _authService.signOut();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr.logout_error)),
          );
        }
      }
    }
  }
}
