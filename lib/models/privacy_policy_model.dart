import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for Privacy Policy version and user acceptance
class PrivacyPolicyModel {
  final String? id;
  final String version;
  final DateTime effectiveDate;
  final String contentAr;
  final String contentEn;
  final bool isActive;
  final DateTime createdAt;

  PrivacyPolicyModel({
    this.id,
    required this.version,
    required this.effectiveDate,
    required this.contentAr,
    required this.contentEn,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'effectiveDate': Timestamp.fromDate(effectiveDate),
      'contentAr': contentAr,
      'contentEn': contentEn,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PrivacyPolicyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrivacyPolicyModel(
      id: doc.id,
      version: data['version'] ?? '1.0',
      effectiveDate: (data['effectiveDate'] as Timestamp).toDate(),
      contentAr: data['contentAr'] ?? '',
      contentEn: data['contentEn'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  PrivacyPolicyModel copyWith({
    String? id,
    String? version,
    DateTime? effectiveDate,
    String? contentAr,
    String? contentEn,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return PrivacyPolicyModel(
      id: id ?? this.id,
      version: version ?? this.version,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      contentAr: contentAr ?? this.contentAr,
      contentEn: contentEn ?? this.contentEn,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Model for tracking user acceptance of privacy policy
class PrivacyPolicyAcceptance {
  final String? id;
  final String userId;
  final String policyVersion;
  final DateTime acceptedAt;
  final String ipAddress;
  final bool accepted;

  PrivacyPolicyAcceptance({
    this.id,
    required this.userId,
    required this.policyVersion,
    required this.acceptedAt,
    this.ipAddress = '',
    this.accepted = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'policyVersion': policyVersion,
      'acceptedAt': Timestamp.fromDate(acceptedAt),
      'ipAddress': ipAddress,
      'accepted': accepted,
    };
  }

  factory PrivacyPolicyAcceptance.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrivacyPolicyAcceptance(
      id: doc.id,
      userId: data['userId'] ?? '',
      policyVersion: data['policyVersion'] ?? '1.0',
      acceptedAt: (data['acceptedAt'] as Timestamp).toDate(),
      ipAddress: data['ipAddress'] ?? '',
      accepted: data['accepted'] ?? true,
    );
  }
}
