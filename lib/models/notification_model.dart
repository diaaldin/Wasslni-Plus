import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  info,
  warning,
  success,
  deliveryUpdate, // delivery_update
}

class NotificationModel {
  final String? id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? relatedParcelId;
  final DateTime createdAt;
  final String? actionUrl;

  NotificationModel({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.relatedParcelId,
    required this.createdAt,
    this.actionUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name, // or custom string mapping if needed
      'isRead': isRead,
      'relatedParcelId': relatedParcelId,
      'createdAt': Timestamp.fromDate(createdAt),
      'actionUrl': actionUrl,
    };
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: _parseType(data['type']),
      isRead: data['isRead'] ?? false,
      relatedParcelId: data['relatedParcelId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      actionUrl: data['actionUrl'],
    );
  }

  static NotificationType _parseType(String? type) {
    switch (type) {
      case 'info':
        return NotificationType.info;
      case 'warning':
        return NotificationType.warning;
      case 'success':
        return NotificationType.success;
      case 'deliveryUpdate':
      case 'delivery_update':
        return NotificationType.deliveryUpdate;
      default:
        return NotificationType.info;
    }
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    String? relatedParcelId,
    DateTime? createdAt,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedParcelId: relatedParcelId ?? this.relatedParcelId,
      createdAt: createdAt ?? this.createdAt,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
