import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/notification_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/flow/shared/notification_preferences_page.dart';
import 'package:wasslni_plus/flow/merchant/parcel/parcel_details_page.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:intl/intl.dart';

class MerchantNotificationsPage extends StatefulWidget {
  const MerchantNotificationsPage({super.key});

  @override
  State<MerchantNotificationsPage> createState() =>
      _MerchantNotificationsPageState();
}

class _MerchantNotificationsPageState extends State<MerchantNotificationsPage> {
  final AuthService _authService = AuthService();
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.notifications),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: tr.notification_settings,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPreferencesPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: tr.mark_all_read,
            onPressed: () => _markAllAsRead(user.uid),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FilterChip(
                  label: Text(tr.all),
                  selected: !_showUnreadOnly,
                  onSelected: (selected) {
                    if (selected) setState(() => _showUnreadOnly = false);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(tr.unread),
                  selected: _showUnreadOnly,
                  onSelected: (selected) {
                    if (selected) setState(() => _showUnreadOnly = true);
                  },
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getNotificationsStream(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                // Client-side filtering for unread if needed
                // (Firestore query can filter, but toggling is smoother client-side for small lists)
                final notifications = docs
                    .map((doc) => NotificationModel.fromFirestore(doc))
                    .where((n) => !_showUnreadOnly || !n.isRead)
                    .toList();

                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr.no_notifications,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification.id!),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deleteNotification(notification.id!),
                      child: _buildNotificationItem(notification),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getNotificationsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      color: notification.isRead
          ? null
          : AppStyles.primaryColor.withValues(alpha: 0.05),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              _getTypeColor(notification.type).withValues(alpha: 0.2),
          child: Icon(
            _getTypeIcon(notification.type),
            color: _getTypeColor(notification.type),
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.body),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMMMd().add_jm().format(notification.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.deliveryUpdate:
        return AppStyles.primaryColor;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.deliveryUpdate:
        return Icons.local_shipping_outlined;
    }
  }

  Future<void> _handleNotificationTap(NotificationModel notification) async {
    if (!notification.isRead) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notification.id)
          .update({'isRead': true});
    }

    // Handle navigation based on relatedParcelId
    if (notification.relatedParcelId != null && mounted) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('parcels')
            .doc(notification.relatedParcelId)
            .get();

        if (doc.exists && mounted) {
          final parcel = ParcelModel.fromFirestore(doc);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParcelDetailsPage(parcel: parcel),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Parcel not found')),
          );
        }
      } catch (e) {
        debugPrint('Error navigating to parcel: $e');
      }
    }
  }

  Future<void> _markAllAsRead(String userId) async {
    final batch = FirebaseFirestore.instance.batch();
    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Future<void> _deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}
