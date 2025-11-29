// lib/models/parcel_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum ParcelStatus {
  awaitingLabel,      // بانتظار الملصق
  readyToShip,        // جاهز للارسال
  enRouteDistributor, // في الطريق للموزع
  atWarehouse,        // مخزن الموزع
  outForDelivery,     // في الطريق للزبون
  delivered,          // تم التوصيل
  returned,           // طرد راجع
  cancelled,          // ملغي
}

class ParcelModel {
  final String? id;
  final String barcode;
  final String merchantId;
  final String? courierId;
  final String? customerId;

  // Recipient Information
  final String recipientName;
  final String recipientPhone;
  final String? recipientAltPhone;
  final String deliveryAddress;
  final String deliveryRegion;

  // Parcel Details
  final String? description;
  final double? weight;
  final Map<String, double>? dimensions;
  final List<String> imageUrls;
  final double parcelPrice;
  final double deliveryFee;
  final double totalPrice;

  // Status & Tracking
  final ParcelStatus status;
  final List<StatusHistory> statusHistory;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;

  // Delivery Details
  final String? proofOfDeliveryUrl;
  final String? signatureUrl;
  final String? deliveryNotes;
  final String? deliveryInstructions;
  final String? returnReason;
  final String? failureReason;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  ParcelModel({
    this.id,
    required this.barcode,
    required this.merchantId,
    this.courierId,
    this.customerId,
    required this.recipientName,
    required this.recipientPhone,
    this.recipientAltPhone,
    required this.deliveryAddress,
    required this.deliveryRegion,
    this.description,
    this.weight,
    this.dimensions,
    this.imageUrls = const [],
    required this.parcelPrice,
    required this.deliveryFee,
    required this.totalPrice,
    this.status = ParcelStatus.awaitingLabel,
    this.statusHistory = const [],
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.proofOfDeliveryUrl,
    this.signatureUrl,
    this.deliveryNotes,
    this.deliveryInstructions,
    this.returnReason,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  // Convert ParcelModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'merchantId': merchantId,
      'courierId': courierId,
      'customerId': customerId,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'recipientAltPhone': recipientAltPhone,
      'deliveryAddress': deliveryAddress,
      'deliveryRegion': deliveryRegion,
      'description': description,
      'weight': weight,
      'dimensions': dimensions,
      'imageUrls': imageUrls,
      'parcelPrice': parcelPrice,
      'deliveryFee': deliveryFee,
      'totalPrice': totalPrice,
      'status': status.name,
      'statusHistory': statusHistory.map((h) => h.toMap()).toList(),
      'estimatedDeliveryTime': estimatedDeliveryTime != null 
          ? Timestamp.fromDate(estimatedDeliveryTime!) 
          : null,
      'actualDeliveryTime': actualDeliveryTime != null 
          ? Timestamp.fromDate(actualDeliveryTime!) 
          : null,
      'proofOfDeliveryUrl': proofOfDeliveryUrl,
      'signatureUrl': signatureUrl,
      'deliveryNotes': deliveryNotes,
      'deliveryInstructions': deliveryInstructions,
      'returnReason': returnReason,
      'failureReason': failureReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isDeleted': isDeleted,
    };
  }

  // Create ParcelModel from Firestore DocumentSnapshot
  factory ParcelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ParcelModel(
      id: doc.id,
      barcode: data['barcode'] ?? '',
      merchantId: data['merchantId'] ?? '',
      courierId: data['courierId'],
      customerId: data['customerId'],
      recipientName: data['recipientName'] ?? '',
      recipientPhone: data['recipientPhone'] ?? '',
      recipientAltPhone: data['recipientAltPhone'],
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryRegion: data['deliveryRegion'] ?? '',
      description: data['description'],
      weight: data['weight']?.toDouble(),
      dimensions: data['dimensions'] != null 
          ? Map<String, double>.from(data['dimensions']) 
          : null,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      parcelPrice: (data['parcelPrice'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: _parseStatus(data['status']),
      statusHistory: (data['statusHistory'] as List<dynamic>?)
              ?.map((h) => StatusHistory.fromMap(h))
              .toList() ??
          [],
      estimatedDeliveryTime: (data['estimatedDeliveryTime'] as Timestamp?)?.toDate(),
      actualDeliveryTime: (data['actualDeliveryTime'] as Timestamp?)?.toDate(),
      proofOfDeliveryUrl: data['proofOfDeliveryUrl'],
      signatureUrl: data['signatureUrl'],
      deliveryNotes: data['deliveryNotes'],
      deliveryInstructions: data['deliveryInstructions'],
      returnReason: data['returnReason'],
      failureReason: data['failureReason'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  static ParcelStatus _parseStatus(String? status) {
    switch (status) {
      case 'awaitingLabel':
        return ParcelStatus.awaitingLabel;
      case 'readyToShip':
        return ParcelStatus.readyToShip;
      case 'enRouteDistributor':
        return ParcelStatus.enRouteDistributor;
      case 'atWarehouse':
        return ParcelStatus.atWarehouse;
      case 'outForDelivery':
        return ParcelStatus.outForDelivery;
      case 'delivered':
        return ParcelStatus.delivered;
      case 'returned':
        return ParcelStatus.returned;
      case 'cancelled':
        return ParcelStatus.cancelled;
      default:
        return ParcelStatus.awaitingLabel;
    }
  }

  ParcelModel copyWith({
    String? id,
    String? barcode,
    String? merchantId,
    String? courierId,
    String? customerId,
    String? recipientName,
    String? recipientPhone,
    String? recipientAltPhone,
    String? deliveryAddress,
    String? deliveryRegion,
    String? description,
    double? weight,
    Map<String, double>? dimensions,
    List<String>? imageUrls,
    double? parcelPrice,
    double? deliveryFee,
    double? totalPrice,
    ParcelStatus? status,
    List<StatusHistory>? statusHistory,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? proofOfDeliveryUrl,
    String? signatureUrl,
    String? deliveryNotes,
    String? deliveryInstructions,
    String? returnReason,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return ParcelModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      merchantId: merchantId ?? this.merchantId,
      courierId: courierId ?? this.courierId,
      customerId: customerId ?? this.customerId,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      recipientAltPhone: recipientAltPhone ?? this.recipientAltPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryRegion: deliveryRegion ?? this.deliveryRegion,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      imageUrls: imageUrls ?? this.imageUrls,
      parcelPrice: parcelPrice ?? this.parcelPrice,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      statusHistory: statusHistory ?? this.statusHistory,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      proofOfDeliveryUrl: proofOfDeliveryUrl ?? this.proofOfDeliveryUrl,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      returnReason: returnReason ?? this.returnReason,
      failureReason: failureReason ?? this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class StatusHistory {
  final ParcelStatus status;
  final DateTime timestamp;
  final String updatedBy;
  final String? location;
  final String? notes;

  StatusHistory({
    required this.status,
    required this.timestamp,
    required this.updatedBy,
    this.location,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'updatedBy': updatedBy,
      'location': location,
      'notes': notes,
    };
  }

  factory StatusHistory.fromMap(Map<String, dynamic> map) {
    return StatusHistory(
      status: ParcelModel._parseStatus(map['status']),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      updatedBy: map['updatedBy'] ?? '',
      location: map['location'],
      notes: map['notes'],
    );
  }
}
