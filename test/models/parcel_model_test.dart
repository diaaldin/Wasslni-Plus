import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

void main() {
  group('ParcelModel', () {
    test('toMap serializes basic fields correctly', () {
      final now = DateTime.now();
      final parcel = ParcelModel(
        barcode: '123456',
        merchantId: 'merchant_123',
        recipientName: 'John Doe',
        recipientPhone: '0501234567',
        deliveryAddress: '123 Main St',
        deliveryRegion: 'Center',
        parcelPrice: 100.0,
        deliveryFee: 20.0,
        totalPrice: 120.0,
        createdAt: now,
        updatedAt: now,
      );

      final map = parcel.toMap();

      expect(map['barcode'], '123456');
      expect(map['merchantId'], 'merchant_123');
      expect(map['recipientName'], 'John Doe');
      expect(map['status'], 'awaitingLabel');
      expect(map['parcelPrice'], 100.0);

      // Verify Timestamps
      expect(map['createdAt'], isA<Timestamp>());
      // We can check fuzzy equality
      final ts = map['createdAt'] as Timestamp;
      expect(ts.toDate().difference(now).inSeconds.abs() < 1, true);
    });

    test('StatusHistory.fromMap parses correctly', () {
      final now = DateTime.now();
      final map = {
        'status': 'delivered',
        'timestamp': Timestamp.fromDate(now),
        'updatedBy': 'courier_1',
        'location': 'Tel Aviv',
        'notes': 'Left at door'
      };

      final history = StatusHistory.fromMap(map);

      expect(history.status, ParcelStatus.delivered);
      expect(history.updatedBy, 'courier_1');
      expect(history.location, 'Tel Aviv');
      expect(history.notes, 'Left at door');
      expect(history.timestamp.difference(now).inSeconds.abs() < 1, true);
    });

    test('ParcelModel.copyWith returns new instance with updated fields', () {
      final now = DateTime.now();
      final parcel = ParcelModel(
        barcode: '123',
        merchantId: 'm1',
        recipientName: 'John',
        recipientPhone: '000',
        deliveryAddress: 'Addr',
        deliveryRegion: 'Reg',
        parcelPrice: 10,
        deliveryFee: 5,
        totalPrice: 15,
        createdAt: now,
        updatedAt: now,
      );

      final updated = parcel.copyWith(status: ParcelStatus.delivered);

      expect(updated.status, ParcelStatus.delivered);
      expect(updated.barcode, '123'); // Should be preserved
      expect(parcel.status,
          ParcelStatus.awaitingLabel); // Original should be unchanged
    });
  });
}
