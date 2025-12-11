import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasslni_plus/services/notification_navigation_service.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/flow/customer/tracking/tracking_page.dart';
import 'package:wasslni_plus/flow/merchant/parcel/parcel_details_page.dart';
import 'package:wasslni_plus/flow/courier/history/delivery_details_page.dart';

/// Widget that listens for notification actions and handles navigation
class NotificationNavigationListener extends StatefulWidget {
  final Widget child;

  const NotificationNavigationListener({
    super.key,
    required this.child,
  });

  @override
  State<NotificationNavigationListener> createState() =>
      _NotificationNavigationListenerState();
}

class _NotificationNavigationListenerState
    extends State<NotificationNavigationListener> {
  final _navigationService = NotificationNavigationService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _listenToNotificationActions();
  }

  void _listenToNotificationActions() {
    _navigationService.notificationStream.listen((action) {
      _handleNotificationAction(action);
    });
  }

  Future<void> _handleNotificationAction(NotificationAction action) async {
    if (!mounted) return;

    final userRole = await _getUserRole();
    if (userRole == null) return;

    switch (action.type) {
      case 'parcel_status_update':
        await _navigateToParcelDetails(
          parcelId: action.parcelId,
          userRole: userRole,
        );
        break;

      case 'new_parcel_assignment':
        await _navigateToParcelDetails(
          parcelId: action.parcelId,
          userRole: userRole,
        );
        break;

      case 'delivery_reminder':
        await _navigateToParcelDetails(
          parcelId: action.parcelId,
          userRole: userRole,
        );
        break;

      default:
        debugPrint('Unknown notification action type: ${action.type}');
    }
  }

  Future<UserRole?> _getUserRole() async {
    final user = await _authService.getCurrentUserData();
    return user?.role;
  }

  Future<void> _navigateToParcelDetails({
    required String? parcelId,
    required UserRole userRole,
  }) async {
    if (parcelId == null || !mounted) return;

    try {
      // Fetch parcel data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(parcelId)
          .get();

      if (!doc.exists || !mounted) {
        _showError('Parcel not found');
        return;
      }

      final parcel = ParcelModel.fromFirestore(doc);

      // Navigate based on user role
      late Widget page;
      switch (userRole) {
        case UserRole.customer:
          page = TrackingPage(parcel: parcel);
          break;
        case UserRole.merchant:
          page = ParcelDetailsPage(parcel: parcel);
          break;
        case UserRole.courier:
          page = DeliveryDetailsPage(parcel: parcel);
          break;
        case UserRole.admin:
        case UserRole.manager:
          page = ParcelDetailsPage(parcel: parcel);
          break;
      }

      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to parcel details: $e');
      _showError('Failed to load parcel details');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
