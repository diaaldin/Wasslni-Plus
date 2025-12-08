import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String? id;
  final String userId;
  final String label; // e.g., "Home", "Work", "Mom's House"
  final String recipientName;
  final String recipientPhone;
  final String address;
  final String city;
  final String region;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.recipientPhone,
    required this.address,
    required this.city,
    required this.region,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'label': label,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'address': address,
      'city': city,
      'region': region,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      label: data['label'] ?? '',
      recipientName: data['recipientName'] ?? '',
      recipientPhone: data['recipientPhone'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      region: data['region'] ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    String? recipientName,
    String? recipientPhone,
    String? address,
    String? city,
    String? region,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
