import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wasslni_plus/services/secure_storage_service.dart';
import 'package:wasslni_plus/models/sync_request.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();

  factory LocalDatabaseService() {
    return _instance;
  }

  LocalDatabaseService._internal();

  bool _isInitialized = false;
  late Box _settingsBox;
  late Box _cacheBox;

  // Box Names
  static const String _settingsBoxName = 'settings_box';
  static const String _cacheBoxName = 'cache_box';

  /// Initialize Hive with encryption
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Get or generate encryption key
    final secureStorage = SecureStorageService();
    String? keyString = await secureStorage.getEncryptionKey();

    List<int> encryptionKey;
    if (keyString == null) {
      // Generate new key
      encryptionKey = Hive.generateSecureKey();
      await secureStorage.saveEncryptionKey(base64Url.encode(encryptionKey));
    } else {
      encryptionKey = base64Url.decode(keyString);
    }

    // Register Adapters
    Hive.registerAdapter(SyncRequestAdapter());

    // Open boxes (encrypted where sensitive)
    _settingsBox = await Hive.openBox(_settingsBoxName);

    // Cache box might contain sensitive user data (synced parcels), so encrypt it
    _cacheBox = await Hive.openBox(
      _cacheBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _isInitialized = true;
  }

  /// Get value from settings
  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  /// Save value to settings
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Cache data
  Future<void> cacheData(String key, dynamic value) async {
    await _cacheBox.put(key, value);
  }

  /// Get cached data
  dynamic getCachedData(String key) {
    return _cacheBox.get(key);
  }
}
