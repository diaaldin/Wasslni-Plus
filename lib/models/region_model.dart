import 'package:cloud_firestore/cloud_firestore.dart';

class RegionModel {
  final String? id;
  final String name;
  final String nameAr;
  final String nameEn;
  final double deliveryFee;
  final bool isActive;
  final int estimatedDeliveryDays;

  RegionModel({
    this.id,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.deliveryFee,
    this.isActive = true,
    this.estimatedDeliveryDays = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'deliveryFee': deliveryFee,
      'isActive': isActive,
      'estimatedDeliveryDays': estimatedDeliveryDays,
    };
  }

  factory RegionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RegionModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameAr: data['nameAr'] ?? '',
      nameEn: data['nameEn'] ?? '',
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? true,
      estimatedDeliveryDays: data['estimatedDeliveryDays'] ?? 1,
    );
  }

  RegionModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? nameEn,
    double? deliveryFee,
    bool? isActive,
    int? estimatedDeliveryDays,
  }) {
    return RegionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      isActive: isActive ?? this.isActive,
      estimatedDeliveryDays:
          estimatedDeliveryDays ?? this.estimatedDeliveryDays,
    );
  }
}
