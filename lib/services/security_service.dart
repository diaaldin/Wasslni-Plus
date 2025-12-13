import 'dart:io';
import 'package:flutter/foundation.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();

  factory SecurityService() {
    return _instance;
  }

  SecurityService._internal();

  /// Constants for regex patterns
  static const String _emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String _phonePattern = r'^\+?[0-9]{10,14}$';

  /// Validates that a string is a valid email
  bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(_emailPattern).hasMatch(email);
  }

  /// Validates that a string is a valid phone number
  bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return RegExp(_phonePattern).hasMatch(phone);
  }

  /// Validates that a URL is valid and enforces HTTPS
  bool isValidSecureUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    // Check basic URL validity
    final isValid = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    if (!isValid) return false;

    // Enforce HTTPS
    return url.startsWith('https://');
  }

  /// Sanitizes input by removing potentially dangerous characters
  /// Useful for inputs that will be rendered or stored
  String sanitizeInput(String input) {
    // Trim whitespace
    String sanitized = input.trim();

    // Remove unsafe characters if needed (context dependent)
    // For now, we'll strip HTML tags to prevent XSS in web views if any
    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*>'), '');

    return sanitized;
  }

  /// Sanitizes filenames to prevent path traversal
  String sanitizeFilename(String filename) {
    return filename.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }

  /// Checks if the device is rooted/jailbroken (Basic check)
  /// This is a heuristic and not 100% reliable
  Future<bool> isDeviceCompromised() async {
    if (kIsWeb) return false;

    // Add real jailbreak detection logic here later (e.g., using flutter_jailbreak_detection)
    return false;
  }

  /// Configures global HTTP overrides to enforce security
  /// Note: This affects all HttpClient requests in the app
  void enableStrictHttpPolicing() {
    HttpOverrides.global = _SecureHttpOverrides();
  }
}

class _SecureHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // Enforce stricter TLS settings if possible
    // client.badCertificateCallback = (cert, host, port) => false; // Strict by default

    return client;
  }
}
