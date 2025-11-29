// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turoudi/models/parcel_model.dart';
import 'package:turoudi/models/user/user_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _parcelsCollection => _firestore.collection('parcels');
  CollectionReference get _regionsCollection => _firestore.collection('regions');
  CollectionReference get _notificationsCollection => _firestore.collection('notifications');

  // ========== USER OPERATIONS ==========

  /// Create a new user
  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user (soft delete)
  Future<void> deleteUser(String uid) async {
    try {
      await _usersCollection.doc(uid).update({'status': 'inactive'});
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// Stream user data (real-time updates)
  Stream<UserModel?> streamUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Get all users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: role)
          .where('status', isEqualTo: 'active')
          .get();
      
      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users by role: $e');
    }
  }

  // ========== PARCEL OPERATIONS ==========

  /// Create a new parcel
  Future<String> createParcel(ParcelModel parcel) async {
    try {
      final docRef = await _parcelsCollection.add(parcel.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create parcel: $e');
    }
  }

  /// Get parcel by ID
  Future<ParcelModel?> getParcel(String parcelId) async {
    try {
      final doc = await _parcelsCollection.doc(parcelId).get();
      if (doc.exists) {
        return ParcelModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get parcel: $e');
    }
  }

  /// Update parcel
  Future<void> updateParcel(String parcelId, Map<String, dynamic> data) async {
    try {
      await _parcelsCollection.doc(parcelId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update parcel: $e');
    }
  }

  /// Delete parcel (soft delete)
  Future<void> deleteParcel(String parcelId) async {
    try {
      await _parcelsCollection.doc(parcelId).update({
        'isDeleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete parcel: $e');
    }
  }

  /// Update parcel status
  Future<void> updateParcelStatus(
    String parcelId,
    ParcelStatus status,
    String updatedBy, {
    String? location,
    String? notes,
  }) async {
    try {
      final parcel = await getParcel(parcelId);
      if (parcel == null) throw Exception('Parcel not found');

      final newHistory = StatusHistory(
        status: status,
        timestamp: DateTime.now(),
        updatedBy: updatedBy,
        location: location,
        notes: notes,
      );

      await _parcelsCollection.doc(parcelId).update({
        'status': status.name,
        'statusHistory': FieldValue.arrayUnion([newHistory.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update parcel status: $e');
    }
  }

  /// Assign courier to parcel
  Future<void> assignCourierToParcel(String parcelId, String courierId) async {
    try {
      await _parcelsCollection.doc(parcelId).update({
        'courierId': courierId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to assign courier: $e');
    }
  }

  /// Stream parcel data (real-time updates)
  Stream<ParcelModel?> streamParcel(String parcelId) {
    return _parcelsCollection.doc(parcelId).snapshots().map((doc) {
      if (doc.exists) {
        return ParcelModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Get parcels by merchant
  Future<List<ParcelModel>> getParcelsByMerchant(String merchantId) async {
    try {
      final querySnapshot = await _parcelsCollection
          .where('merchantId', isEqualTo: merchantId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ParcelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get parcels by merchant: $e');
    }
  }

  /// Stream parcels by merchant (real-time)
  Stream<List<ParcelModel>> streamParcelsByMerchant(String merchantId) {
    return _parcelsCollection
        .where('merchantId', isEqualTo: merchantId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParcelModel.fromFirestore(doc))
            .toList());
  }

  /// Get parcels by courier
  Future<List<ParcelModel>> getParcelsByCourier(String courierId) async {
    try {
      final querySnapshot = await _parcelsCollection
          .where('courierId', isEqualTo: courierId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ParcelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get parcels by courier: $e');
    }
  }

  /// Stream parcels by courier (real-time)
  Stream<List<ParcelModel>> streamParcelsByCourier(String courierId) {
    return _parcelsCollection
        .where('courierId', isEqualTo: courierId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParcelModel.fromFirestore(doc))
            .toList());
  }

  /// Get parcels by status
  Future<List<ParcelModel>> getParcelsByStatus(ParcelStatus status) async {
    try {
      final querySnapshot = await _parcelsCollection
          .where('status', isEqualTo: status.name)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ParcelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get parcels by status: $e');
    }
  }

  /// Get parcels by region
  Future<List<ParcelModel>> getParcelsByRegion(String region) async {
    try {
      final querySnapshot = await _parcelsCollection
          .where('deliveryRegion', isEqualTo: region)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ParcelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get parcels by region: $e');
    }
  }

  /// Search parcel by barcode
  Future<ParcelModel?> searchParcelByBarcode(String barcode) async {
    try {
      final querySnapshot = await _parcelsCollection
          .where('barcode', isEqualTo: barcode)
          .where('isDeleted', isEqualTo: false)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return ParcelModel.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to search parcel by barcode: $e');
    }
  }

  // ========== REGION OPERATIONS ==========

  /// Get all regions
  Future<List<Map<String, dynamic>>> getAllRegions() async {
    try {
      final querySnapshot = await _regionsCollection
          .where('isActive', isEqualTo: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to get regions: $e');
    }
  }

  /// Stream all regions (real-time)
  Stream<List<Map<String, dynamic>>> streamAllRegions() {
    return _regionsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }

  /// Get delivery fee for a region
  Future<double> getDeliveryFee(String regionName) async {
    try {
      final querySnapshot = await _regionsCollection
          .where('name', isEqualTo: regionName)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return (querySnapshot.docs.first.data() as Map<String, dynamic>)['deliveryFee']?.toDouble() ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      throw Exception('Failed to get delivery fee: $e');
    }
  }

  // ========== NOTIFICATION OPERATIONS ==========

  /// Create notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    String type = 'info',
    String? relatedParcelId,
    String? actionUrl,
  }) async {
    try {
      await _notificationsCollection.add({
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'isRead': false,
        'relatedParcelId': relatedParcelId,
        'actionUrl': actionUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Get user notifications
  Stream<List<Map<String, dynamic>>> streamUserNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // ========== UTILITY OPERATIONS ==========

  /// Initialize default regions (run once on app setup)
  Future<void> initializeDefaultRegions() async {
    try {
      final regions = [
        {
          'name': 'القدس',
          'nameAr': 'القدس',
          'nameEn': 'Jerusalem',
          'nameHe': 'ירושלים',
          'deliveryFee': 30,
          'isActive': true,
          'estimatedDeliveryDays': 1,
        },
        {
          'name': 'الضفة',
          'nameAr': 'الضفة',
          'nameEn': 'West Bank',
          'nameHe': 'הגדה',
          'deliveryFee': 20,
          'isActive': true,
          'estimatedDeliveryDays': 1,
        },
        {
          'name': 'الداخل',
          'nameAr': 'الداخل',
          'nameEn': 'Inside',
          'nameHe': 'הפנים',
          'deliveryFee': 70,
          'isActive': true,
          'estimatedDeliveryDays': 2,
        },
      ];

      final batch = _firestore.batch();
      for (var region in regions) {
        final docRef = _regionsCollection.doc();
        batch.set(docRef, region);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to initialize regions: $e');
    }
  }

  /// Generate unique barcode
  Future<String> generateUniqueBarcode() async {
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      final barcode = DateTime.now().millisecondsSinceEpoch.toString();
      final existing = await searchParcelByBarcode(barcode);
      
      if (existing == null) {
        return barcode;
      }
      
      attempts++;
      await Future.delayed(const Duration(milliseconds: 10));
    }

    throw Exception('Failed to generate unique barcode');
  }
}
