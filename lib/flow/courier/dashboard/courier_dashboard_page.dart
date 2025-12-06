import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:intl/intl.dart';

class CourierDashboardPage extends StatefulWidget {
  const CourierDashboardPage({super.key});

  @override
  State<CourierDashboardPage> createState() => _CourierDashboardPageState();
}

class _CourierDashboardPageState extends State<CourierDashboardPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.courier_dashboard),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: StreamBuilder<List<ParcelModel>>(
        stream: _getTodaysDeliveries(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final parcels = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Statistics Cards
                  _buildStatisticsCards(parcels, tr),
                  const SizedBox(height: 24),

                  // Today's Assignments Header
                  Text(
                    tr.daily_assignments,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Assignments List
                  if (parcels.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              tr.no_assignments,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...parcels.map((parcel) => _buildParcelCard(parcel, tr)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Stream<List<ParcelModel>> _getTodaysDeliveries(String courierId) {
    // Get today's start and end timestamps
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    // Stream parcels assigned to this courier for today
    return _firestoreService.streamCourierParcels(
      courierId,
      startDate: todayStart,
      endDate: todayEnd,
    );
  }

  Widget _buildStatisticsCards(List<ParcelModel> parcels, S tr) {
    final totalDeliveries = parcels.length;
    final completedDeliveries =
        parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final pendingPickup =
        parcels.where((p) => p.status == ParcelStatus.pending).length;
    final inTransit =
        parcels.where((p) => p.status == ParcelStatus.inTransit).length;

    // Calculate earnings (sum of delivery fees for completed deliveries)
    final earningsToday = parcels
        .where((p) => p.status == ParcelStatus.delivered)
        .fold<double>(0, (sum, p) => sum + p.deliveryFee);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: tr.todays_deliveries,
                value: totalDeliveries.toString(),
                icon: Icons.local_shipping,
                color: AppStyles.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: tr.earnings_today,
                value: '₪${earningsToday.toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: tr.completed,
                value: completedDeliveries.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: tr.pending_pickup,
                value: pendingPickup.toString(),
                icon: Icons.schedule,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: tr.in_transit,
                value: inTransit.toString(),
                icon: Icons.delivery_dining,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelCard(ParcelModel parcel, S tr) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(parcel.status).withOpacity(0.2),
          child: Icon(
            _getStatusIcon(parcel.status),
            color: _getStatusColor(parcel.status),
            size: 20,
          ),
        ),
        title: Text(
          '#${parcel.trackingNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${tr.recipient}: ${parcel.recipientName}'),
            Text('📍 ${parcel.deliveryCity}, ${parcel.deliveryRegion}'),
            Text(
              _getStatusText(parcel.status, tr),
              style: TextStyle(
                color: _getStatusColor(parcel.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Text(
          '₪${parcel.deliveryFee.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        onTap: () {
          // TODO: Navigate to delivery details
        },
      ),
    );
  }

  Color _getStatusColor(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.pending:
        return Colors.orange;
      case ParcelStatus.pickedUp:
        return Colors.blue;
      case ParcelStatus.inTransit:
        return AppStyles.primaryColor;
      case ParcelStatus.delivered:
        return Colors.green;
      case ParcelStatus.failed:
        return Colors.red;
      case ParcelStatus.cancelled:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.pending:
        return Icons.schedule;
      case ParcelStatus.pickedUp:
        return Icons.inventory_2;
      case ParcelStatus.inTransit:
        return Icons.local_shipping;
      case ParcelStatus.delivered:
        return Icons.check_circle;
      case ParcelStatus.failed:
        return Icons.error;
      case ParcelStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(ParcelStatus status, S tr) {
    switch (status) {
      case ParcelStatus.pending:
        return tr.pending_pickup;
      case ParcelStatus.pickedUp:
        return 'Picked Up';
      case ParcelStatus.inTransit:
        return tr.in_transit;
      case ParcelStatus.delivered:
        return tr.completed;
      case ParcelStatus.failed:
        return 'Failed';
      case ParcelStatus.cancelled:
        return 'Cancelled';
    }
  }
}
