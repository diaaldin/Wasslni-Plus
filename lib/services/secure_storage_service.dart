import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Keys for stored data
  static const String _authTokenKey = 'auth_token';
  static const String _encryptionKey = 'hive_encryption_key';

  /// Save auth token securely
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  /// Get auth token
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  /// Delete auth token
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  /// Save encryption key for local database (Hive)
  Future<void> saveEncryptionKey(String key) async {
    await _storage.write(key: _encryptionKey, value: key);
  }

  /// Get encryption key for local database
  Future<String?> getEncryptionKey() async {
    return await _storage.read(key: _encryptionKey);
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
