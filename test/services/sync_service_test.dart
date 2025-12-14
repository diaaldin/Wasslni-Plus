import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasslni_plus/models/sync_request.dart';
import 'dart:io';

void main() {
  group('SyncService Queue Logic Tests', () {
    late Directory testDir;

    setUpAll(() async {
      // Create temporary directory for Hive
      testDir = await Directory.systemTemp.createTemp('sync_service_test_');
      Hive.init(testDir.path);

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(SyncRequestAdapter());
      }
    });

    tearDownAll(() async {
      await Hive.close();
      await testDir.delete(recursive: true);
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('Queue should store sync requests when offline', () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_test');

      try {
        // Simulate adding items to queue
        final request1 = SyncRequest(
          collection: 'parcels',
          documentId: 'doc1',
          data: {'status': 'pending'},
          action: 'update',
          timestamp: DateTime.now(),
        );

        final request2 = SyncRequest(
          collection: 'users',
          documentId: 'user1',
          data: {'name': 'Test User'},
          action: 'set',
          timestamp: DateTime.now(),
        );

        await box.add(request1);
        await box.add(request2);

        // Verify queue has 2 items
        expect(box.length, equals(2));
        expect(box.getAt(0)?.collection, equals('parcels'));
        expect(box.getAt(1)?.collection, equals('users'));
      } finally {
        await box.close();
      }
    });

    test('Queue should process items in FIFO order', () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_fifo');

      try {
        // Add multiple requests with timestamps
        final timestamps = [
          DateTime(2024, 1, 1, 10, 0, 0),
          DateTime(2024, 1, 1, 11, 0, 0),
          DateTime(2024, 1, 1, 12, 0, 0),
        ];

        for (int i = 0; i < timestamps.length; i++) {
          await box.add(SyncRequest(
            collection: 'test',
            documentId: 'doc$i',
            data: {'index': i},
            action: 'create',
            timestamp: timestamps[i],
          ));
        }

        // Process queue (simulate FIFO)
        final processedItems = <SyncRequest>[];
        for (var key in box.keys) {
          final item = box.get(key);
          if (item != null) {
            processedItems.add(item);
          }
        }

        // Verify order
        expect(processedItems.length, equals(3));
        expect(processedItems[0].data['index'], equals(0));
        expect(processedItems[1].data['index'], equals(1));
        expect(processedItems[2].data['index'], equals(2));
      } finally {
        await box.close();
      }
    });

    test('Queue should handle timestamp conversion for DateTime', () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_datetime');

      try {
        final testDate = DateTime(2024, 1, 15, 10, 30, 0);

        // Simulate SyncService's _convertTimestamps
        final data = {
          'createdAt': testDate,
          'name': 'Test',
        };

        final convertedData = _convertTimestamps(data);

        // Verify DateTime is converted to a serializable format
        expect(convertedData['createdAt'], isA<Map>());
        expect(convertedData['createdAt']['_type'], equals('DateTime'));
        expect(convertedData['createdAt']['value'],
            equals(testDate.toIso8601String()));
        expect(convertedData['name'], equals('Test'));

        // Store and retrieve
        final request = SyncRequest(
          collection: 'test',
          documentId: 'doc1',
          data: convertedData,
          action: 'create',
          timestamp: DateTime.now(),
        );

        await box.add(request);
        final retrieved = box.getAt(0);

        expect(retrieved, isNotNull);
        expect(retrieved!.data['createdAt']['_type'], equals('DateTime'));

        // Simulate SyncService's _restoreTimestamps
        final restoredData = _restoreTimestamps(retrieved.data);
        expect(restoredData['createdAt'], isA<DateTime>());
        expect(restoredData['createdAt'], equals(testDate));
      } finally {
        await box.close();
      }
    });

    test('Queue should handle timestamp conversion for Firestore Timestamp',
        () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_timestamp');

      try {
        final testTimestamp = Timestamp(1705315800, 500000000); // Jan 15, 2024

        final data = {
          'updatedAt': testTimestamp,
          'value': 42,
        };

        final convertedData = _convertTimestamps(data);

        // Verify Timestamp is converted
        expect(convertedData['updatedAt'], isA<Map>());
        expect(convertedData['updatedAt']['_type'], equals('Timestamp'));
        expect(convertedData['updatedAt']['seconds'], equals(1705315800));
        expect(convertedData['updatedAt']['nanoseconds'], equals(500000000));

        // Store and retrieve
        final request = SyncRequest(
          collection: 'test',
          documentId: 'doc1',
          data: convertedData,
          action: 'update',
          timestamp: DateTime.now(),
        );

        await box.add(request);
        final retrieved = box.getAt(0);

        // Restore timestamps
        final restoredData = _restoreTimestamps(retrieved!.data);
        expect(restoredData['updatedAt'], isA<Timestamp>());
        final restored = restoredData['updatedAt'] as Timestamp;
        expect(restored.seconds, equals(1705315800));
        expect(restored.nanoseconds, equals(500000000));
      } finally {
        await box.close();
      }
    });

    test('Queue should remove successfully processed items', () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_removal');

      try {
        // Add 3 items
        for (int i = 0; i < 3; i++) {
          await box.add(SyncRequest(
            collection: 'test',
            documentId: 'doc$i',
            data: {'index': i},
            action: 'create',
            timestamp: DateTime.now(),
          ));
        }

        expect(box.length, equals(3));

        // Simulate successful processing of first item
        final firstKey = box.keys.first;
        await box.delete(firstKey);

        expect(box.length, equals(2));
        expect(
            box.getAt(0)?.data['index'], equals(1)); // Second item is now first
      } finally {
        await box.close();
      }
    });

    test('Queue should keep failed items for retry', () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_retry');

      try {
        final request = SyncRequest(
          collection: 'test',
          documentId: 'doc1',
          data: {'value': 'test'},
          action: 'create',
          timestamp: DateTime.now(),
        );

        await box.add(request);

        // Simulate processing failure - item should remain in queue
        final firstKey = box.keys.first;
        final item = box.get(firstKey);

        expect(item, isNotNull);

        // Don't delete on failure
        // await box.delete(firstKey); // This would only happen on success

        // Verify item is still in queue
        expect(box.length, equals(1));
        expect(box.get(firstKey), isNotNull);
      } finally {
        await box.close();
      }
    });

    test('Queue should handle different action types correctly', () async {
      final box = await Hive.openBox<SyncRequest>('sync_queue_actions');

      try {
        final actions = ['create', 'update', 'set', 'delete'];

        for (final action in actions) {
          await box.add(SyncRequest(
            collection: 'test',
            documentId: 'doc-$action',
            data: {'action': action},
            action: action,
            timestamp: DateTime.now(),
          ));
        }

        expect(box.length, equals(4));

        // Verify each action is stored correctly
        var index = 0;
        for (var key in box.keys) {
          final item = box.get(key);
          expect(item, isNotNull);
          expect(item!.action, equals(actions[index]));
          index++;
        }
      } finally {
        await box.close();
      }
    });

    test('Timestamp conversion should handle mixed data types', () {
      final now = DateTime.now();
      final timestamp = Timestamp.now();

      final data = {
        'dateField': now,
        'timestampField': timestamp,
        'stringField': 'test',
        'numberField': 42,
        'boolField': true,
      };

      final converted = _convertTimestamps(data);

      // DateTime should be converted
      expect(converted['dateField'], isA<Map>());
      expect(converted['dateField']['_type'], equals('DateTime'));

      // Timestamp should be converted
      expect(converted['timestampField'], isA<Map>());
      expect(converted['timestampField']['_type'], equals('Timestamp'));

      // Other fields should remain unchanged
      expect(converted['stringField'], equals('test'));
      expect(converted['numberField'], equals(42));
      expect(converted['boolField'], equals(true));

      // Restore and verify
      final restored = _restoreTimestamps(converted);
      expect(restored['dateField'], isA<DateTime>());
      expect(restored['timestampField'], isA<Timestamp>());
      expect(restored['stringField'], equals('test'));
      expect(restored['numberField'], equals(42));
      expect(restored['boolField'], equals(true));
    });
  });
}

// Helper functions to mirror SyncService's timestamp conversion logic
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
