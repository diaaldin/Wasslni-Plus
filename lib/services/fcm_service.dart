import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/services/auth_service.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  // Handle background message here if needed
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize FCM
  Future<void> initialize() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('FCM Permission granted: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get FCM token
        _fcmToken = await _messaging.getToken();
        debugPrint('FCM Token: $_fcmToken');

        // Save token to Firestore if user is authenticated
        if (_authService.isAuthenticated() && _fcmToken != null) {
          final user = _authService.currentUser;
          if (user != null) {
            await _firestoreService.updateUserFcmToken(user.uid, _fcmToken!);
          }
        }

        // Listen for token refresh
        _messaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          debugPrint('FCM Token refreshed: $newToken');

          // Update token in Firestore
          if (_authService.isAuthenticated()) {
            final user = _authService.currentUser;
            if (user != null) {
              _firestoreService.updateUserFcmToken(user.uid, newToken);
            }
          }
        });

        // Set up message handlers
        _setupMessageHandlers();
      } else {
        debugPrint('FCM Permission denied');
      }
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  /// Set up foreground and background message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.messageId}');
      _handleMessage(message, isBackground: false);
    });

    // Handle background messages (when app is in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Background message opened: ${message.messageId}');
      _handleMessage(message, isBackground: true);
    });

    // Handle notification tap when app was terminated
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App opened from terminated state: ${message.messageId}');
        _handleMessage(message, isBackground: true);
      }
    });
  }

  /// Handle incoming message
  void _handleMessage(RemoteMessage message, {required bool isBackground}) {
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint('Message notification: ${message.notification!.title}');
      debugPrint('Message body: ${message.notification!.body}');
    }

    // Handle different notification types based on data
    final String? type = message.data['type'];
    final String? parcelId = message.data['parcelId'];

    switch (type) {
      case 'parcel_status_update':
        _handleParcelStatusUpdate(parcelId, message.data);
        break;
      case 'new_parcel_assignment':
        _handleNewParcelAssignment(parcelId, message.data);
        break;
      case 'delivery_reminder':
        _handleDeliveryReminder(parcelId, message.data);
        break;
      case 'promotional':
        _handlePromotionalNotification(message.data);
        break;
      case 'system_announcement':
        _handleSystemAnnouncement(message.data);
        break;
      default:
        debugPrint('Unknown notification type: $type');
    }
  }

  /// Handle parcel status update notification
  void _handleParcelStatusUpdate(String? parcelId, Map<String, dynamic> data) {
    if (parcelId == null) return;
    debugPrint('Parcel $parcelId status updated');
    // Navigate to parcel details or refresh parcel list
    // This will be implemented in the UI layer
  }

  /// Handle new parcel assignment notification (for couriers)
  void _handleNewParcelAssignment(String? parcelId, Map<String, dynamic> data) {
    if (parcelId == null) return;
    debugPrint('New parcel assigned: $parcelId');
    // Navigate to parcel details or refresh courier dashboard
  }

  /// Handle delivery reminder notification
  void _handleDeliveryReminder(String? parcelId, Map<String, dynamic> data) {
    if (parcelId == null) return;
    debugPrint('Delivery reminder for parcel: $parcelId');
    // Show reminder dialog or navigate to parcel
  }

  /// Handle promotional notification
  void _handlePromotionalNotification(Map<String, dynamic> data) {
    debugPrint('Promotional notification received');
    // Navigate to promotional page or show dialog
  }

  /// Handle system announcement
  void _handleSystemAnnouncement(Map<String, dynamic> data) {
    debugPrint('System announcement received');
    // Show announcement dialog or banner
  }

  /// Subscribe to topic (for role-based or region-based notifications)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Subscribe to role-based topics
  Future<void> subscribeToRoleTopics(String role) async {
    // Subscribe to role-specific topic
    await subscribeToTopic('role_$role');

    // Subscribe to all users topic
    await subscribeToTopic('all_users');
  }

  /// Subscribe to region-based topics
  Future<void> subscribeToRegionTopics(List<String> regions) async {
    for (String region in regions) {
      await subscribeToTopic('region_$region');
    }
  }

  /// Unsubscribe from all topics (on logout)
  Future<void> unsubscribeFromAllTopics(
      String role, List<String>? regions) async {
    await unsubscribeFromTopic('role_$role');
    await unsubscribeFromTopic('all_users');

    if (regions != null) {
      for (String region in regions) {
        await unsubscribeFromTopic('region_$region');
      }
    }
  }

  /// Delete FCM token (on logout)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
      debugPrint('FCM token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }
}
