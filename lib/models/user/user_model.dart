// lib/models/user/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasslni_plus/models/user/consts.dart';

class UserModel {
  final String? uid;
  final String phoneNumber;
  final String? email;
  final String name;
  final UserRole role;
  final String? profilePhotoUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final UserStatus status;
  final String? preferredLanguage;
  final bool isDarkMode;
  final String? fcmToken;
  final Map<String, bool>? notificationSettings;

  // Merchant-specific fields
  final String? businessName;
  final String? businessAddress;
  final String? businessLicense;

  // Courier-specific fields
  final String? vehicleType;
  final String? vehiclePlate;
  final List<String>? workingRegions;
  final bool? availability;
  final double? rating;
  final int? totalDeliveries;

  // Manager-specific fields
  final List<String>? managedRegions;
  final String? branchId;

  UserModel({
    this.uid,
    required this.phoneNumber,
    this.email,
    required this.name,
    required this.role,
    this.profilePhotoUrl,
    required this.createdAt,
    this.lastLogin,
    this.status = UserStatus.active,
    this.preferredLanguage,
    this.isDarkMode = false,
    this.fcmToken,
    this.notificationSettings,
    // Merchant fields
    this.businessName,
    this.businessAddress,
    this.businessLicense,
    // Courier fields
    this.vehicleType,
    this.vehiclePlate,
    this.workingRegions,
    this.availability,
    this.rating,
    this.totalDeliveries,
    // Manager fields
    this.managedRegions,
    this.branchId,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'email': email,
      'name': name,
      'role': role.name,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'status': status.name,
      'preferredLanguage': preferredLanguage,
      'isDarkMode': isDarkMode,
      'fcmToken': fcmToken,
      'notificationSettings': notificationSettings,
      // Merchant fields
      if (role == UserRole.merchant) ...{
        'businessName': businessName,
        'businessAddress': businessAddress,
        'businessLicense': businessLicense,
      },
      // Courier fields
      if (role == UserRole.courier) ...{
        'vehicleType': vehicleType,
        'vehiclePlate': vehiclePlate,
        'workingRegions': workingRegions,
        'availability': availability,
        'rating': rating,
        'totalDeliveries': totalDeliveries,
      },
      // Manager fields
      if (role == UserRole.manager) ...{
        'managedRegions': managedRegions,
        'branchId': branchId,
      },
    };
  }

  // Create from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'],
      name: data['name'] ?? '',
      role: _parseRole(data['role']),
      profilePhotoUrl: data['profilePhotoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
      status: _parseStatus(data['status']),
      preferredLanguage: data['preferredLanguage'],
      isDarkMode: data['isDarkMode'] ?? false,
      fcmToken: data['fcmToken'],
      notificationSettings: data['notificationSettings'] != null
          ? Map<String, bool>.from(data['notificationSettings'])
          : null,
      // Merchant fields
      businessName: data['businessName'],
      businessAddress: data['businessAddress'],
      businessLicense: data['businessLicense'],
      // Courier fields
      vehicleType: data['vehicleType'],
      vehiclePlate: data['vehiclePlate'],
      workingRegions: data['workingRegions'] != null
          ? List<String>.from(data['workingRegions'])
          : null,
      availability: data['availability'],
      rating: data['rating']?.toDouble(),
      totalDeliveries: data['totalDeliveries'],
      // Manager fields
      managedRegions: data['managedRegions'] != null
          ? List<String>.from(data['managedRegions'])
          : null,
      branchId: data['branchId'],
    );
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      case 'merchant':
        return UserRole.merchant;
      case 'courier':
        return UserRole.courier;
      case 'customer':
        return UserRole.customer;
      default:
        return UserRole.customer;
    }
  }

  static UserStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      default:
        return UserStatus.active;
    }
  }

  UserModel copyWith({
    String? uid,
    String? phoneNumber,
    String? email,
    String? name,
    UserRole? role,
    String? profilePhotoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    UserStatus? status,
    String? preferredLanguage,
    bool? isDarkMode,
    String? fcmToken,
    Map<String, bool>? notificationSettings,
    String? businessName,
    String? businessAddress,
    String? businessLicense,
    String? vehicleType,
    String? vehiclePlate,
    List<String>? workingRegions,
    bool? availability,
    double? rating,
    int? totalDeliveries,
    List<String>? managedRegions,
    String? branchId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      status: status ?? this.status,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fcmToken: fcmToken ?? this.fcmToken,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      businessLicense: businessLicense ?? this.businessLicense,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      workingRegions: workingRegions ?? this.workingRegions,
      availability: availability ?? this.availability,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      managedRegions: managedRegions ?? this.managedRegions,
      branchId: branchId ?? this.branchId,
    );
  }

  // Helper getters
  bool get isMerchant => role == UserRole.merchant;
  bool get isCourier => role == UserRole.courier;
  bool get isCustomer => role == UserRole.customer;
  bool get isManager => role == UserRole.manager;
  bool get isAdmin => role == UserRole.admin;

  bool get isActive => status == UserStatus.active;
  bool get isAvailable => availability == true && isActive;
}

enum UserStatus {
  active,
  inactive,
  suspended,
}
