import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to manage app settings from Firestore
class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream that listens to the merchant_admin setting
  /// Returns true if merchants should have admin access, false otherwise
  Stream<bool> get merchantAdminStream {
    print('📡 SettingsService: Creating stream for settings/app_settings');
    return _firestore
        .collection('settings')
        .doc('app_settings')
        .snapshots()
        .map((snapshot) {
      print('📄 Firestore snapshot received: exists=${snapshot.exists}');

      if (!snapshot.exists) {
        print('❌ Document does not exist at settings/app_settings');
        return false; // Default to false if document doesn't exist
      }

      final data = snapshot.data();
      print('📊 Document data: $data');

      if (data == null) {
        print('⚠️ Document exists but data is null');
        return false;
      }

      // Get merchant_admin field, default to false if not present
      final merchantAdmin = data['merchant_admin'] as bool? ?? false;
      print('✅ merchant_admin value: $merchantAdmin');
      return merchantAdmin;
    });
  }

  /// Get the current merchant_admin value (one-time read)
  Future<bool> getMerchantAdminSetting() async {
    try {
      final doc =
          await _firestore.collection('settings').doc('app_settings').get();

      if (!doc.exists) {
        return false;
      }

      final data = doc.data();
      if (data == null) {
        return false;
      }

      return data['merchant_admin'] as bool? ?? false;
    } catch (e) {
      // If error occurs, default to false (restricted access)
      return false;
    }
  }

  /// Update the merchant_admin setting (admin only function)
  Future<void> setMerchantAdminSetting(bool value) async {
    await _firestore
        .collection('settings')
        .doc('app_settings')
        .set({'merchant_admin': value}, SetOptions(merge: true));
  }
}
