import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/region_model.dart';
import 'package:wasslni_plus/models/notification_model.dart';
import 'package:wasslni_plus/models/review_model.dart';
import 'package:wasslni_plus/models/analytics_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _parcelsCollection =>
      _firestore.collection('parcels');
  CollectionReference get _regionsCollection =>
      _firestore.collection('regions');
  CollectionReference get _notificationsCollection =>
      _firestore.collection('notifications');
  CollectionReference get _reviewsCollection =>
      _firestore.collection('reviews');
  CollectionReference get _analyticsCollection =>
      _firestore.collection('analytics');

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

  /// Update FCM token
  Future<void> updateUserFcmToken(String uid, String token) async {
    try {
      await _usersCollection.doc(uid).update({'fcmToken': token});
    } catch (e) {
      throw Exception('Failed to update FCM token: $e');
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

  /// Batch create parcels (Bulk upload)
  Future<void> batchCreateParcels(List<ParcelModel> parcels) async {
    try {
      final batch = _firestore.batch();
      for (var parcel in parcels) {
        final docRef = _parcelsCollection.doc(); // Auto-ID
        batch.set(docRef, parcel.toMap());
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch create parcels: $e');
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
    String? reason,
  }) async {
    try {
      final parcel = await getParcel(parcelId);
      if (parcel == null) throw Exception('Parcel not found');

      final newHistory = StatusHistory(
        status: status,
        timestamp: DateTime.now(),
        updatedBy: updatedBy,
        location: location,
        notes: notes ?? reason, // Use reason as notes if notes not provided
      );

      final Map<String, dynamic> updateData = {
        'status': status.name,
        'statusHistory': FieldValue.arrayUnion([newHistory.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (status == ParcelStatus.returned && reason != null) {
        updateData['returnReason'] = reason;
      } else if ((status == ParcelStatus.cancelled) && reason != null) {
        updateData['failureReason'] =
            reason; // Use failureReason for cancelled too if needed, or mapped.
        // Actually model has failureReason, usually for "Failed Attempt".
        // Let's assume Cancelled might imply failure or manual cancellation.
        // If status is cancelled, let's set failureReason as generic reason field.
      }

      await _parcelsCollection.doc(parcelId).update(updateData);
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
        // Removed orderBy to avoid composite index requirement
        // We'll sort in memory instead
        .snapshots()
        .map((snapshot) {
      final parcels =
          snapshot.docs.map((doc) => ParcelModel.fromFirestore(doc)).toList();
      // Sort in memory by createdAt descending
      parcels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return parcels;
    });
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

  /// Stream parcels for courier with date filtering (for daily assignments)
  Stream<List<ParcelModel>> streamCourierParcels(
    String courierId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _parcelsCollection
        .where('courierId', isEqualTo: courierId)
        .where('isDeleted', isEqualTo: false);

    if (startDate != null) {
      query = query.where('createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query = query.where('createdAt', isLessThan: Timestamp.fromDate(endDate));
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ParcelModel.fromFirestore(doc)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  /// Get parcels by customer
  Future<List<ParcelModel>> getParcelsByCustomer(String customerId) async {
    try {
      final querySnapshot = await _parcelsCollection
          .where('customerId', isEqualTo: customerId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ParcelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get parcels by customer: $e');
    }
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
  Future<List<RegionModel>> getAllRegions() async {
    try {
      final querySnapshot =
          await _regionsCollection.where('isActive', isEqualTo: true).get();

      return querySnapshot.docs
          .map((doc) => RegionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get regions: $e');
    }
  }

  /// Create region (Admin)
  Future<void> createRegion(RegionModel region) async {
    try {
      // Use English name as ID
      await _regionsCollection.doc(region.nameEn).set(region.toMap());
    } catch (e) {
      throw Exception('Failed to create region: $e');
    }
  }

  /// Update region (Admin)
  Future<void> updateRegion(String regionId, Map<String, dynamic> data) async {
    try {
      await _regionsCollection.doc(regionId).update(data);
    } catch (e) {
      throw Exception('Failed to update region: $e');
    }
  }

  /// Stream all regions (real-time)
  Stream<List<RegionModel>> streamAllRegions() {
    return _regionsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegionModel.fromFirestore(doc))
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
        return (querySnapshot.docs.first.data()
                    as Map<String, dynamic>)['deliveryFee']
                ?.toDouble() ??
            0.0;
      }
      return 0.0;
    } catch (e) {
      throw Exception('Failed to get delivery fee: $e');
    }
  }

  // ========== NOTIFICATION OPERATIONS ==========

  /// Create notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _notificationsCollection.add(notification.toMap());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Get user notifications
  Stream<List<NotificationModel>> streamUserNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationsCollection
          .doc(notificationId)
          .update({'isRead': true});
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

  // ========== REVIEW OPERATIONS ==========

  /// Create review
  Future<void> createReview(ReviewModel review) async {
    try {
      await _reviewsCollection.add(review.toMap());

      // Update courier rating
      await _updateCourierRating(review.courierId);
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  /// Get reviews by courier
  Future<List<ReviewModel>> getReviewsByCourier(String courierId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('courierId', isEqualTo: courierId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reviews by courier: $e');
    }
  }

  /// Get reviews by parcel
  Future<List<ReviewModel>> getReviewsByParcel(String parcelId) async {
    try {
      final querySnapshot =
          await _reviewsCollection.where('parcelId', isEqualTo: parcelId).get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reviews by parcel: $e');
    }
  }

  /// Update courier rating (Internal helper)
  Future<void> _updateCourierRating(String courierId) async {
    try {
      final reviews = await getReviewsByCourier(courierId);
      if (reviews.isEmpty) return;

      final totalRating =
          reviews.fold(0.0, (total, review) => total + review.rating);
      final averageRating = totalRating / reviews.length;

      await updateUser(courierId, {
        'rating': averageRating,
        'totalDeliveries':
            FieldValue.increment(0), // Just to ensure field exists
      });
    } catch (e) {
      debugPrint('Error updating courier rating: $e');
    }
  }

  // ========== ANALYTICS OPERATIONS ==========

  /// Get daily analytics
  Future<AnalyticsModel?> getDailyAnalytics(String date) async {
    try {
      final doc = await _analyticsCollection.doc(date).get();
      if (doc.exists) {
        return AnalyticsModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get daily analytics: $e');
    }
  }

  // ========== UTILITY OPERATIONS ==========

  /// Initialize default regions (run once on app setup)
  Future<void> initializeDefaultRegions() async {
    try {
      final regions = [
        RegionModel(
          name: 'القدس',
          nameAr: 'القدس',
          nameEn: 'Jerusalem',
          deliveryFee: 30,
          isActive: true,
          estimatedDeliveryDays: 1,
        ),
        RegionModel(
          name: 'الضفة',
          nameAr: 'الضفة',
          nameEn: 'West Bank',
          deliveryFee: 20,
          isActive: true,
          estimatedDeliveryDays: 1,
        ),
        RegionModel(
          name: 'الداخل',
          nameAr: 'الداخل',
          nameEn: 'Inside',
          deliveryFee: 70,
          isActive: true,
          estimatedDeliveryDays: 2,
        ),
      ];

      final batch = _firestore.batch();
      for (var region in regions) {
        // Use English name as ID to prevent duplicates
        final docRef = _regionsCollection.doc(region.nameEn);
        batch.set(docRef, region.toMap(), SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to initialize regions: $e');
    }
  }

  /// Generate unique barcode
  Future<String> generateUniqueBarcode() async {
    // Generate barcode using timestamp + random number to avoid permission issues
    // Format: timestamp(13 digits) + random(3 digits) = 16 digit barcode
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (100 + DateTime.now().microsecond % 900).toString();
    return timestamp + random;
  }
}
