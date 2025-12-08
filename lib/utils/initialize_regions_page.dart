import 'package:flutter/material.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/app_styles.dart';

class InitializeRegionsPage extends StatefulWidget {
  const InitializeRegionsPage({super.key});

  @override
  State<InitializeRegionsPage> createState() => _InitializeRegionsPageState();
}

class _InitializeRegionsPageState extends State<InitializeRegionsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isInitializing = false;
  String _statusMessage = '';

  Future<void> _initializeRegions() async {
    setState(() {
      _isInitializing = true;
      _statusMessage = 'Initializing regions...';
    });

    try {
      await _firestoreService.initializeDefaultRegions();
      setState(() {
        _statusMessage = 'Regions initialized successfully!';
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialize Regions'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.public,
                size: 80,
                color: AppStyles.primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Initialize Default Regions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This will create default delivery regions:\n• Jerusalem\n• West Bank\n• Inside',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_statusMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _statusMessage.contains('Error')
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _statusMessage.contains('Error')
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isInitializing ? null : _initializeRegions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: _isInitializing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Initialize Regions',
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
