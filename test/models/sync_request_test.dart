import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:wasslni_plus/models/sync_request.dart';
import 'dart:io';

void main() {
  group('SyncRequest Hive Serialization Tests', () {
    late Directory testDir;

    setUpAll(() async {
      // Create a temporary directory for Hive testing
      testDir = await Directory.systemTemp.createTemp('hive_test_');

      // Initialize Hive with temp directory
      Hive.init(testDir.path);

      // Register the adapter
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(SyncRequestAdapter());
      }
    });

    tearDownAll(() async {
      await Hive.close();
      await testDir.delete(recursive: true);
    });

    tearDown(() async {
      // Close all boxes after each test
      await Hive.deleteFromDisk();
    });

    test('SyncRequest should serialize and deserialize correctly', () async {
      // Open a box for testing
      final box = await Hive.openBox<SyncRequest>('test_sync_requests');

      try {
        // Create a test sync request
        final originalRequest = SyncRequest(
          collection: 'parcels',
          documentId: 'test-doc-123',
          data: {
            'name': 'Test Parcel',
            'status': 'pending',
            'amount': 100.50,
          },
          action: 'create',
          timestamp: DateTime(2024, 1, 15, 10, 30, 0),
        );

        // Save to Hive
        await box.put('test_key', originalRequest);

        // Retrieve from Hive
        final retrievedRequest = box.get('test_key');

        // Verify the retrieved request matches the original
        expect(retrievedRequest, isNotNull);
        expect(retrievedRequest!.collection, equals('parcels'));
        expect(retrievedRequest.documentId, equals('test-doc-123'));
        expect(retrievedRequest.data['name'], equals('Test Parcel'));
        expect(retrievedRequest.data['status'], equals('pending'));
        expect(retrievedRequest.data['amount'], equals(100.50));
        expect(retrievedRequest.action, equals('create'));
        expect(retrievedRequest.timestamp,
            equals(DateTime(2024, 1, 15, 10, 30, 0)));
      } finally {
        await box.close();
      }
    });

    test('SyncRequest should handle null documentId', () async {
      final box = await Hive.openBox<SyncRequest>('test_sync_requests_null');

      try {
        final request = SyncRequest(
          collection: 'users',
          documentId: null, // Auto-generated ID
          data: {'email': 'test@example.com'},
          action: 'set',
          timestamp: DateTime.now(),
        );

        await box.put('null_id_test', request);
        final retrieved = box.get('null_id_test');

        expect(retrieved, isNotNull);
        expect(retrieved!.documentId, isNull);
        expect(retrieved.collection, equals('users'));
      } finally {
        await box.close();
      }
    });

    test('SyncRequest should persist different action types', () async {
      final box = await Hive.openBox<SyncRequest>('test_sync_actions');

      try {
        final actions = ['create', 'update', 'delete', 'set'];

        for (int i = 0; i < actions.length; i++) {
          final request = SyncRequest(
            collection: 'test_collection',
            documentId: 'doc-$i',
            data: {'index': i},
            action: actions[i],
            timestamp: DateTime.now(),
          );

          await box.put('action_$i', request);
        }

        // Verify all actions were saved correctly
        for (int i = 0; i < actions.length; i++) {
          final retrieved = box.get('action_$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.action, equals(actions[i]));
        }
      } finally {
        await box.close();
      }
    });

    test('SyncRequest should handle complex nested data', () async {
      final box = await Hive.openBox<SyncRequest>('test_complex_data');

      try {
        final complexData = {
          'name': 'Complex Object',
          'nested': {
            'level1': {
              'level2': 'deep value',
            },
          },
          'list': [1, 2, 3],
          'mixed': ['string', 42, true],
        };

        final request = SyncRequest(
          collection: 'complex',
          documentId: 'complex-1',
          data: complexData,
          action: 'update',
          timestamp: DateTime.now(),
        );

        await box.put('complex', request);
        final retrieved = box.get('complex');

        expect(retrieved, isNotNull);
        expect(retrieved!.data['name'], equals('Complex Object'));
        expect(
            retrieved.data['nested']['level1']['level2'], equals('deep value'));
        expect(retrieved.data['list'], equals([1, 2, 3]));
        expect(retrieved.data['mixed'], equals(['string', 42, true]));
      } finally {
        await box.close();
      }
    });

    test('SyncRequest should handle empty data map', () async {
      final box = await Hive.openBox<SyncRequest>('test_empty_data');

      try {
        final request = SyncRequest(
          collection: 'test',
          documentId: 'doc-1',
          data: {},
          action: 'delete',
          timestamp: DateTime.now(),
        );

        await box.put('empty', request);
        final retrieved = box.get('empty');

        expect(retrieved, isNotNull);
        expect(retrieved!.data, isEmpty);
        expect(retrieved.action, equals('delete'));
      } finally {
        await box.close();
      }
    });
  });
}
