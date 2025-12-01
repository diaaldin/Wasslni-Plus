import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsModel {
  final String date; // format: YYYY-MM-DD, used as ID
  final int totalParcels;
  final int deliveredParcels;
  final int returnedParcels;
  final int failedParcels;
  final double totalRevenue;
  final double averageDeliveryTime; // in hours or minutes
  final Map<String, int> byRegion;
  final Map<String, int> byCourier;
  final Map<String, int> byStatus;

  AnalyticsModel({
    required this.date,
    this.totalParcels = 0,
    this.deliveredParcels = 0,
    this.returnedParcels = 0,
    this.failedParcels = 0,
    this.totalRevenue = 0.0,
    this.averageDeliveryTime = 0.0,
    this.byRegion = const {},
    this.byCourier = const {},
    this.byStatus = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'totalParcels': totalParcels,
      'deliveredParcels': deliveredParcels,
      'returnedParcels': returnedParcels,
      'failedParcels': failedParcels,
      'totalRevenue': totalRevenue,
      'averageDeliveryTime': averageDeliveryTime,
      'byRegion': byRegion,
      'byCourier': byCourier,
      'byStatus': byStatus,
    };
  }

  factory AnalyticsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnalyticsModel(
      date: doc.id,
      totalParcels: data['totalParcels'] ?? 0,
      deliveredParcels: data['deliveredParcels'] ?? 0,
      returnedParcels: data['returnedParcels'] ?? 0,
      failedParcels: data['failedParcels'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
      averageDeliveryTime: (data['averageDeliveryTime'] ?? 0).toDouble(),
      byRegion: Map<String, int>.from(data['byRegion'] ?? {}),
      byCourier: Map<String, int>.from(data['byCourier'] ?? {}),
      byStatus: Map<String, int>.from(data['byStatus'] ?? {}),
    );
  }

  AnalyticsModel copyWith({
    String? date,
    int? totalParcels,
    int? deliveredParcels,
    int? returnedParcels,
    int? failedParcels,
    double? totalRevenue,
    double? averageDeliveryTime,
    Map<String, int>? byRegion,
    Map<String, int>? byCourier,
    Map<String, int>? byStatus,
  }) {
    return AnalyticsModel(
      date: date ?? this.date,
      totalParcels: totalParcels ?? this.totalParcels,
      deliveredParcels: deliveredParcels ?? this.deliveredParcels,
      returnedParcels: returnedParcels ?? this.returnedParcels,
      failedParcels: failedParcels ?? this.failedParcels,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      averageDeliveryTime: averageDeliveryTime ?? this.averageDeliveryTime,
      byRegion: byRegion ?? this.byRegion,
      byCourier: byCourier ?? this.byCourier,
      byStatus: byStatus ?? this.byStatus,
    );
  }
}
