import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Service for managing Firebase Performance Monitoring
class PerformanceMonitoringService {
  static final PerformanceMonitoringService _instance =
      PerformanceMonitoringService._internal();
  factory PerformanceMonitoringService() => _instance;
  PerformanceMonitoringService._internal();

  final FirebasePerformance _performance = FirebasePerformance.instance;

  // Track active traces
  final Map<String, Trace> _activeTraces = {};

  /// Initialize Performance Monitoring
  Future<void> initialize() async {
    try {
      // Enable performance monitoring collection
      await _performance.setPerformanceCollectionEnabled(true);

      debugPrint('Performance Monitoring initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Performance Monitoring: $e');
    }
  }

  // ========== CUSTOM TRACES ==========

  /// Start a custom trace
  /// Use this to measure the duration of specific operations
  Future<void> startTrace(String traceName) async {
    try {
      if (_activeTraces.containsKey(traceName)) {
        debugPrint('Trace "$traceName" is already running');
        return;
      }

      final trace = _performance.newTrace(traceName);
      await trace.start();
      _activeTraces[traceName] = trace;

      debugPrint('Started trace: $traceName');
    } catch (e) {
      debugPrint('Error starting trace "$traceName": $e');
    }
  }

  /// Stop a custom trace
  Future<void> stopTrace(String traceName) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace == null) {
        debugPrint('Trace "$traceName" not found or already stopped');
        return;
      }

      await trace.stop();
      _activeTraces.remove(traceName);

      debugPrint('Stopped trace: $traceName');
    } catch (e) {
      debugPrint('Error stopping trace "$traceName": $e');
    }
  }

  /// Add a metric to an active trace
  Future<void> incrementMetric(
    String traceName,
    String metricName,
    int value,
  ) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace == null) {
        debugPrint('Trace "$traceName" not found');
        return;
      }

      trace.incrementMetric(metricName, value);
      debugPrint(
          'Incremented metric "$metricName" by $value in trace "$traceName"');
    } catch (e) {
      debugPrint('Error incrementing metric: $e');
    }
  }

  /// Set a custom attribute for a trace
  Future<void> putAttribute(
    String traceName,
    String attributeName,
    String value,
  ) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace == null) {
        debugPrint('Trace "$traceName" not found');
        return;
      }

      trace.putAttribute(attributeName, value);
      debugPrint(
          'Set attribute "$attributeName" = "$value" in trace "$traceName"');
    } catch (e) {
      debugPrint('Error setting attribute: $e');
    }
  }

  // ========== HTTP REQUEST TRACKING ==========

  /// Create an HTTP metric for monitoring network requests
  /// Returns a HttpMetric that should be started before the request
  /// and stopped after receiving the response
  HttpMetric createHttpMetric(String url, HttpMethod method) {
    return _performance.newHttpMetric(url, method);
  }

  /// Convenience method to track HTTP requests
  /// Usage:
  /// ```dart
  /// await performanceService.trackHttpRequest(
  ///   url: 'https://api.example.com/data',
  ///   method: HttpMethod.Get,
  ///   action: () async {
  ///     // Your HTTP request code
  ///     return await http.get(...);
  ///   },
  /// );
  /// ```
  Future<T> trackHttpRequest<T>({
    required String url,
    required HttpMethod method,
    required Future<T> Function() action,
    int? responseCode,
    int? requestPayloadSize,
    int? responsePayloadSize,
    String? responseContentType,
  }) async {
    final metric = createHttpMetric(url, method);
    await metric.start();

    try {
      final result = await action();

      // Set response details if provided
      if (responseCode != null) {
        metric.httpResponseCode = responseCode;
      }
      if (requestPayloadSize != null) {
        metric.requestPayloadSize = requestPayloadSize;
      }
      if (responsePayloadSize != null) {
        metric.responsePayloadSize = responsePayloadSize;
      }
      if (responseContentType != null) {
        metric.responseContentType = responseContentType;
      }

      await metric.stop();
      return result;
    } catch (e) {
      // Stop metric even if request fails
      await metric.stop();
      rethrow;
    }
  }

  // ========== PREDEFINED TRACES FOR COMMON OPERATIONS ==========

  /// Track app startup time
  Future<void> startAppStartupTrace() async {
    await startTrace('app_startup');
  }

  Future<void> stopAppStartupTrace() async {
    await stopTrace('app_startup');
  }

  /// Track user login
  Future<void> startLoginTrace() async {
    await startTrace('user_login');
  }

  Future<void> stopLoginTrace() async {
    await stopTrace('user_login');
  }

  /// Track parcel creation
  Future<void> startParcelCreationTrace() async {
    await startTrace('parcel_creation');
  }

  Future<void> stopParcelCreationTrace() async {
    await stopTrace('parcel_creation');
  }

  /// Track image upload
  Future<void> startImageUploadTrace() async {
    await startTrace('image_upload');
  }

  Future<void> stopImageUploadTrace() async {
    await stopTrace('image_upload');
  }

  /// Track PDF generation
  Future<void> startPdfGenerationTrace() async {
    await startTrace('pdf_generation');
  }

  Future<void> stopPdfGenerationTrace() async {
    await stopTrace('pdf_generation');
  }

  /// Track barcode scanning
  Future<void> startBarcodeScanTrace() async {
    await startTrace('barcode_scan');
  }

  Future<void> stopBarcodeScanTrace() async {
    await stopTrace('barcode_scan');
  }

  /// Track dashboard loading
  Future<void> startDashboardLoadTrace(String role) async {
    await startTrace('dashboard_load_$role');
  }

  Future<void> stopDashboardLoadTrace(String role) async {
    await stopTrace('dashboard_load_$role');
  }

  /// Track Firestore queries
  Future<void> startFirestoreQueryTrace(String queryName) async {
    await startTrace('firestore_query_$queryName');
  }

  Future<void> stopFirestoreQueryTrace(String queryName) async {
    await stopTrace('firestore_query_$queryName');
  }

  // ========== HELPER METHODS ==========

  /// Execute an operation with automatic trace tracking
  /// Usage:
  /// ```dart
  /// final result = await performanceService.traceOperation(
  ///   'my_operation',
  ///   () async {
  ///     // Your operation code
  ///     return someValue;
  ///   },
  ///   attributes: {'user_role': 'merchant'},
  ///   metrics: {'items_count': 10},
  /// );
  /// ```
  Future<T> traceOperation<T>(
    String traceName,
    Future<T> Function() operation, {
    Map<String, String>? attributes,
    Map<String, int>? metrics,
  }) async {
    await startTrace(traceName);

    try {
      // Add attributes if provided
      if (attributes != null) {
        for (final entry in attributes.entries) {
          await putAttribute(traceName, entry.key, entry.value);
        }
      }

      // Execute the operation
      final result = await operation();

      // Add metrics if provided
      if (metrics != null) {
        for (final entry in metrics.entries) {
          await incrementMetric(traceName, entry.key, entry.value);
        }
      }

      await stopTrace(traceName);
      return result;
    } catch (e) {
      // Stop trace even if operation fails
      await stopTrace(traceName);
      rethrow;
    }
  }

  /// Check if a trace is currently active
  bool isTraceActive(String traceName) {
    return _activeTraces.containsKey(traceName);
  }

  /// Get all active trace names
  List<String> getActiveTraceNames() {
    return _activeTraces.keys.toList();
  }

  /// Stop all active traces (useful for cleanup)
  Future<void> stopAllTraces() async {
    final traceNames = _activeTraces.keys.toList();
    for (final traceName in traceNames) {
      await stopTrace(traceName);
    }
  }
}
