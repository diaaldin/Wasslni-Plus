import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/models/user/user_model.dart';

void main() {
  group('UserModel', () {
    test('toMap serializes basic fields and role correctly (Merchant)', () {
      final now = DateTime.now();
      final user = UserModel(
        uid: 'uid123',
        phoneNumber: '0501111111',
        name: 'Merchant User',
        role: UserRole.merchant,
        createdAt: now,
        businessName: 'My Shop',
      );

      final map = user.toMap();

      expect(map['name'], 'Merchant User');
      expect(map['role'], 'merchant');
      expect(map['businessName'], 'My Shop');
      expect(map['createdAt'], isA<Timestamp>());
    });

    test('toMap serializes Courier specific fields', () {
      final now = DateTime.now();
      final user = UserModel(
        uid: 'uid456',
        phoneNumber: '0502222222',
        name: 'Courier User',
        role: UserRole.courier,
        createdAt: now,
        vehicleType: 'Bike',
        workingRegions: ['North', 'South'],
      );

      final map = user.toMap();

      expect(map['role'], 'courier');
      expect(map['vehicleType'], 'Bike');
      expect(map['workingRegions'], ['North', 'South']);
    });

    test('copyWith updates fields', () {
      final now = DateTime.now();
      final user = UserModel(
        uid: 'uid',
        phoneNumber: '000',
        name: 'Name',
        role: UserRole.customer,
        createdAt: now,
      );

      final updated = user.copyWith(name: 'New Name', role: UserRole.admin);

      expect(updated.name, 'New Name');
      expect(updated.role, UserRole.admin);
      expect(updated.phoneNumber, '000'); // Unchanged
    });

    test('helper getters work correctly', () {
      final user = UserModel(
        phoneNumber: '000',
        name: 'Name',
        role: UserRole.merchant,
        createdAt: DateTime.now(),
      );

      expect(user.isMerchant, true);
      expect(user.isCourier, false);
    });
  });
}
