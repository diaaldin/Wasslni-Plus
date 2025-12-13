import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wasslni_plus/models/sync_request.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  Box<SyncRequest>? _queueBox;
  bool _isProcessing = false;

  /// Initialize the sync service
  Future<void> initialize() async {
    // Open queue box
    // Note: ensure SyncRequestAdapter is registered in LocalDatabaseService before this
    _queueBox = await Hive.openBox<SyncRequest>('sync_queue');

    // Process queue if we have internet initially
    _checkConnectivityAndProcess();

    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        _processQueue();
      }
    });
  }

  void _checkConnectivityAndProcess() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet) {
      _processQueue();
    }
  }

  /// Add a write operation to the sync queue
  Future<void> addToQueue({
    required String collection,
    String? documentId,
    required Map<String, dynamic> data,
    required String action, // 'create', 'update', 'set'
  }) async {
    final request = SyncRequest(
      collection: collection,
      documentId: documentId,
      data: _convertTimestamps(data), // Ensure serializable
      action: action,
      timestamp: DateTime.now(),
    );

    await _queueBox?.add(request);

    // Try to process immediately if online
    _checkConnectivityAndProcess();
  }

  /// Process all queued requests
  Future<void> _processQueue() async {
    if (_isProcessing || (_queueBox?.isEmpty ?? true)) return;

    _isProcessing = true;
    print('SyncService: Processing ${_queueBox!.length} items in queue...');

    // Get all items to process (keys to delete later)
    // We create a copy to iterate because we delete as we go (or delete after success)
    final keys = _queueBox!.keys.toList();

    for (var key in keys) {
      final SyncRequest? request = _queueBox!.get(key);
      if (request == null) continue;

      try {
        await _performFirestoreAction(request);
        await _queueBox!.delete(key);
        print(
            'SyncService: Processed item $key (${request.action} ${request.collection})');
      } catch (e) {
        print('SyncService: Error processing item $key: $e');
        // Keep in queue for retry
      }
    }

    _isProcessing = false;
  }

  Future<void> _performFirestoreAction(SyncRequest request) async {
    final docRef = request.documentId != null
        ? _firestore.collection(request.collection).doc(request.documentId)
        : _firestore.collection(request.collection).doc(); // Auto-id if null

    final data = _restoreTimestamps(request.data);

    switch (request.action) {
      case 'create':
        // For create, if we didn't have an ID, we used .add() equivalent logic
        if (request.documentId == null) {
          await _firestore.collection(request.collection).add(data);
        } else {
          await docRef.set(data);
        }
        break;
      case 'set':
        await docRef.set(data);
        break;
      case 'update':
        await docRef.update(data);
        break;
      case 'delete':
        await docRef.delete();
        break;
      default:
        throw Exception('Unknown action: ${request.action}');
    }
  }

  // Helpers to handle DateTime/Timestamp serialization for Hive
  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final newData = Map<String, dynamic>.from(data);
    newData.forEach((key, value) {
      if (value is DateTime) {
        newData[key] = {'_type': 'DateTime', 'value': value.toIso8601String()};
      } else if (value is Timestamp) {
        newData[key] = {
          '_type': 'Timestamp',
          'seconds': value.seconds,
          'nanoseconds': value.nanoseconds
        };
      }
      // Shallow copy, so nested maps are not processed
    });
    return newData;
  }

  Map<String, dynamic> _restoreTimestamps(Map<dynamic, dynamic> data) {
    final newData = Map<String, dynamic>.from(data);
    newData.forEach((key, value) {
      if (value is Map && value.containsKey('_type')) {
        if (value['_type'] == 'DateTime') {
          newData[key] = DateTime.parse(value['value']);
        } else if (value['_type'] == 'Timestamp') {
          newData[key] = Timestamp(value['seconds'], value['nanoseconds']);
        }
      }
    });
    return newData;
  }
}
