import 'package:flutter/material.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/app_styles.dart';

class FixUserDocumentPage extends StatefulWidget {
  const FixUserDocumentPage({super.key});

  @override
  State<FixUserDocumentPage> createState() => _FixUserDocumentPageState();
}

class _FixUserDocumentPageState extends State<FixUserDocumentPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isFixing = false;
  String _statusMessage = '';

  Future<void> _fixUserDocument() async {
    final user = _authService.currentUser;
    if (user == null) {
      setState(() {
        _statusMessage = 'Error: Not logged in';
      });
      return;
    }

    setState(() {
      _isFixing = true;
      _statusMessage = 'Checking user document...';
    });

    try {
      // Check if user document exists
      final existingUser = await _firestoreService.getUser(user.uid);

      if (existingUser != null) {
        setState(() {
          _statusMessage =
              'User document already exists!\nName: ${existingUser.name}\nRole: ${existingUser.role.name}';
          _isFixing = false;
        });
        return;
      }

      // User document doesn't exist, create it
      setState(() {
        _statusMessage = 'Creating user document...';
      });

      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'Courier User',
        phoneNumber: user.phoneNumber ?? '',
        role: UserRole.courier, // Default to courier, user can be edited later
        profilePhotoUrl: user.photoURL ?? '',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        status: UserStatus.active,
        preferredLanguage: 'ar',
        isDarkMode: false,
        fcmToken: '',
      );

      await _firestoreService.createUser(newUser);

      setState(() {
        _statusMessage =
            'Success! User document created.\nPlease refresh the app.';
        _isFixing = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isFixing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fix User Document'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.build,
                size: 80,
                color: AppStyles.primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Fix Missing User Document',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (user != null) ...[
                Text(
                  'Logged in as:\n${user.email ?? user.phoneNumber ?? user.uid}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 32),
              if (_statusMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _statusMessage.contains('Error')
                        ? Colors.red.withValues(alpha: 0.1)
                        : _statusMessage.contains('Success')
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _statusMessage.contains('Error')
                          ? Colors.red
                          : _statusMessage.contains('Success')
                              ? Colors.green
                              : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isFixing ? null : _fixUserDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: _isFixing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Check & Fix User Document',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
