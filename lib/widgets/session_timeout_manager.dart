import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wasslni_plus/services/auth_service.dart';

class SessionTimeoutManager extends StatefulWidget {
  final Widget child;
  final Duration timeoutDuration;
  final VoidCallback? onTimeout;

  const SessionTimeoutManager({
    Key? key,
    required this.child,
    this.timeoutDuration = const Duration(minutes: 30), // Default 30 minutes
    this.onTimeout,
  }) : super(key: key);

  @override
  State<SessionTimeoutManager> createState() => _SessionTimeoutManagerState();
}

class _SessionTimeoutManagerState extends State<SessionTimeoutManager> {
  Timer? _timer;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeoutDuration, _handleTimeout);
  }

  void _handleUserInteraction([_]) {
    _startTimer();
  }

  Future<void> _handleTimeout() async {
    if (widget.onTimeout != null) {
      widget.onTimeout!();
    } else {
      // Default behavior: Sign out
      if (_authService.isAuthenticated()) {
        await _authService.signOut();
        // You might want to navigate to login screen here or show a dialog
        // But since this widget wraps the app, navigation might be tricky without context
        // Ideally, the auth state change listener in main.dart will handle the navigation
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      onPointerUp: _handleUserInteraction,
      child: widget.child,
    );
  }
}
