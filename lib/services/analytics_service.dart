import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Initialize Analytics and Crashlytics
  Future<void> initialize() async {
    try {
      // Enable analytics collection
      await _analytics.setAnalyticsCollectionEnabled(true);

      // Initialize Crashlytics
      await _initializeCrashlytics();

      debugPrint('Analytics and Crashlytics initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Analytics/Crashlytics: $e');
    }
  }

  /// Initialize Crashlytics
  Future<void> _initializeCrashlytics() async {
    // Crashlytics is not supported on web, skip initialization
    if (kIsWeb) {
      debugPrint(
          'Crashlytics is not supported on web, skipping initialization');
      return;
    }

    // Pass all uncaught errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Enable Crashlytics collection
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  // ========== USER PROPERTIES ==========

  /// Set user ID for analytics
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setUserIdentifier(userId);
      }
    } catch (e) {
      debugPrint('Error setting user ID: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String role,
    String? region,
    String? language,
  }) async {
    try {
      await _analytics.setUserProperty(name: 'user_role', value: role);

      if (region != null) {
        await _analytics.setUserProperty(name: 'user_region', value: region);
      }

      if (language != null) {
        await _analytics.setUserProperty(
            name: 'user_language', value: language);
      }

      // Also set for Crashlytics (not on web)
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setCustomKey('user_role', role);
        if (region != null) {
          await FirebaseCrashlytics.instance
              .setCustomKey('user_region', region);
        }
      }
    } catch (e) {
      debugPrint('Error setting user properties: $e');
    }
  }

  /// Clear user data on logout
  Future<void> clearUserData() async {
    try {
      await _analytics.setUserId(id: null);
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setUserIdentifier('');
      }
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }

  // ========== SCREEN TRACKING ==========

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      debugPrint('Error logging screen view: $e');
    }
  }

  // ========== AUTHENTICATION EVENTS ==========

  /// Log login event
  Future<void> logLogin(String method) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      debugPrint('Error logging login: $e');
    }
  }

  /// Log signup event
  Future<void> logSignUp(String method) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
    } catch (e) {
      debugPrint('Error logging signup: $e');
    }
  }

  // ========== PARCEL EVENTS ==========

  /// Log parcel creation
  Future<void> logParcelCreated({
    required String parcelId,
    required String merchantId,
    required String region,
    required double deliveryFee,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'parcel_created',
        parameters: {
          'parcel_id': parcelId,
          'merchant_id': merchantId,
          'region': region,
          'delivery_fee': deliveryFee,
        },
      );
    } catch (e) {
      debugPrint('Error logging parcel creation: $e');
    }
  }

  /// Log parcel status change
  Future<void> logParcelStatusChange({
    required String parcelId,
    required String oldStatus,
    required String newStatus,
    required String updatedBy,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'parcel_status_changed',
        parameters: {
          'parcel_id': parcelId,
          'old_status': oldStatus,
          'new_status': newStatus,
          'updated_by': updatedBy,
        },
      );
    } catch (e) {
      debugPrint('Error logging parcel status change: $e');
    }
  }

  /// Log parcel delivery
  Future<void> logParcelDelivered({
    required String parcelId,
    required String courierId,
    required double deliveryTime, // in hours
  }) async {
    try {
      await _analytics.logEvent(
        name: 'parcel_delivered',
        parameters: {
          'parcel_id': parcelId,
          'courier_id': courierId,
          'delivery_time_hours': deliveryTime,
        },
      );
    } catch (e) {
      debugPrint('Error logging parcel delivery: $e');
    }
  }

  // ========== COURIER EVENTS ==========

  /// Log courier assignment
  Future<void> logCourierAssignment({
    required String parcelId,
    required String courierId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'courier_assigned',
        parameters: {
          'parcel_id': parcelId,
          'courier_id': courierId,
        },
      );
    } catch (e) {
      debugPrint('Error logging courier assignment: $e');
    }
  }

  // ========== REVIEW EVENTS ==========

  /// Log review submission
  Future<void> logReviewSubmitted({
    required String parcelId,
    required String courierId,
    required double rating,
    double? tip,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'review_submitted',
        parameters: {
          'parcel_id': parcelId,
          'courier_id': courierId,
          'rating': rating,
          if (tip != null) 'tip_amount': tip,
        },
      );
    } catch (e) {
      debugPrint('Error logging review submission: $e');
    }
  }

  // ========== SEARCH EVENTS ==========

  /// Log search
  Future<void> logSearch(String searchTerm) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
    } catch (e) {
      debugPrint('Error logging search: $e');
    }
  }

  // ========== ERROR TRACKING ==========

  /// Log non-fatal error
  Future<void> logError({
    required dynamic error,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    if (kIsWeb) {
      debugPrint(
          'Error logged (web): $error ${reason != null ? "- $reason" : ""}');
      return;
    }
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('Error logging error: $e');
    }
  }

  /// Log custom message
  Future<void> logMessage(String message) async {
    if (kIsWeb) {
      debugPrint('Message logged (web): $message');
      return;
    }
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      debugPrint('Error logging message: $e');
    }
  }

  /// Set custom key for crash reports
  Future<void> setCustomKey(String key, dynamic value) async {
    if (kIsWeb) {
      debugPrint('Custom key set (web): $key = $value');
      return;
    }
    try {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error setting custom key: $e');
    }
  }

  // ========== CUSTOM EVENTS ==========

  /// Log custom event
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters?.cast<String, Object>(),
      );
    } catch (e) {
      debugPrint('Error logging custom event: $e');
    }
  }
}
