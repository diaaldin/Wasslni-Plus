import 'dart:async';
import 'package:flutter/material.dart';

/// Notification action model
class NotificationAction {
  final String type;
  final String? parcelId;
  final Map<String, dynamic> data;

  NotificationAction({
    required this.type,
    this.parcelId,
    required this.data,
  });
}

/// Service to handle navigation from push notifications
/// Uses a stream-based approach to decouple FCM from UI navigation
class NotificationNavigationService {
  static final NotificationNavigationService _instance =
      NotificationNavigationService._internal();
  factory NotificationNavigationService() => _instance;
  NotificationNavigationService._internal();

  // Global navigator key for app-wide navigation
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Stream controller for notification actions
  final _notificationActionController =
      StreamController<NotificationAction>.broadcast();

  // Stream of notification actions that UI can listen to
  Stream<NotificationAction> get notificationStream =>
      _notificationActionController.stream;

  /// Emit a notification action to be handled by the UI
  void handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final parcelId = data['parcelId'] as String?;

    if (type == null) {
      debugPrint('Notification data missing type field');
      return;
    }

    debugPrint(
        'Notification tapped: type=$type, parcelId=$parcelId, data=$data');

    final action = NotificationAction(
      type: type,
      parcelId: parcelId,
      data: data,
    );

    _notificationActionController.add(action);
  }

  /// Show a foreground notification as a SnackBar
  void showForegroundNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null || !context.mounted) {
      debugPrint('Navigator context not available for foreground notification');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(body),
          ],
        ),
        action: data != null
            ? SnackBarAction(
                label: 'View',
                onPressed: () {
                  handleNotificationTap(data);
                },
              )
            : null,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Dispose the stream controller
  void dispose() {
    _notificationActionController.close();
  }
}
