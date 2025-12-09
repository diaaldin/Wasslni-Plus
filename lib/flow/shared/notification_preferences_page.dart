import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/services/auth_service.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  // Settings state
  bool _parcelUpdates = true;
  bool _promotionalOffers = true;
  bool _systemAnnouncements = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.getCurrentUserData();
      if (user != null && user.notificationSettings != null) {
        setState(() {
          _parcelUpdates = user.notificationSettings!['parcelUpdates'] ?? true;
          _promotionalOffers =
              user.notificationSettings!['promotionalOffers'] ?? true;
          _systemAnnouncements =
              user.notificationSettings!['systemAnnouncements'] ?? true;
        });
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _authService.updateNotificationSettings({
        'parcelUpdates': _parcelUpdates,
        'promotionalOffers': _promotionalOffers,
        'systemAnnouncements': _systemAnnouncements,
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.notification_settings),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSwitchTile(
                  title: tr.parcel_updates,
                  subtitle: tr.parcel_updates_desc,
                  value: _parcelUpdates,
                  onChanged: (value) {
                    setState(() => _parcelUpdates = value);
                    _saveSettings();
                  },
                ),
                const Divider(),
                _buildSwitchTile(
                  title: tr.promotional_offers,
                  subtitle: tr.promotional_offers_desc,
                  value: _promotionalOffers,
                  onChanged: (value) {
                    setState(() => _promotionalOffers = value);
                    _saveSettings();
                  },
                ),
                const Divider(),
                _buildSwitchTile(
                  title: tr.system_announcements,
                  subtitle: tr.system_announcements_desc,
                  value: _systemAnnouncements,
                  onChanged: (value) {
                    setState(() => _systemAnnouncements = value);
                    _saveSettings();
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppStyles.primaryColor,
    );
  }
}
