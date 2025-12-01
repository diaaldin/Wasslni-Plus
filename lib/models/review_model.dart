import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String? id;
  final String parcelId;
  final String customerId;
  final String courierId;
  final double rating; // 1-5
  final String? comment;
  final double? tip;
  final DateTime createdAt;

  ReviewModel({
    this.id,
    required this.parcelId,
    required this.customerId,
    required this.courierId,
    required this.rating,
    this.comment,
    this.tip,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'parcelId': parcelId,
      'customerId': customerId,
      'courierId': courierId,
      'rating': rating,
      'comment': comment,
      'tip': tip,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      parcelId: data['parcelId'] ?? '',
      customerId: data['customerId'] ?? '',
      courierId: data['courierId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'],
      tip: data['tip']?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  ReviewModel copyWith({
    String? id,
    String? parcelId,
    String? customerId,
    String? courierId,
    double? rating,
    String? comment,
    double? tip,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      parcelId: parcelId ?? this.parcelId,
      customerId: customerId ?? this.customerId,
      courierId: courierId ?? this.courierId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      tip: tip ?? this.tip,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
