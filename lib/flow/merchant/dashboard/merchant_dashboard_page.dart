import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

class MerchantDashboardPage extends StatefulWidget {
  const MerchantDashboardPage({super.key});

  @override
  State<MerchantDashboardPage> createState() => _MerchantDashboardPageState();
}

class _MerchantDashboardPageState extends State<MerchantDashboardPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  int _pendingCount = 0;
  int _inTransitCount = 0;
  int _deliveredCount = 0;
  double _totalRevenue = 0;
  List<ParcelModel> _recentParcels = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user == null) return;

      // Get current month's date range
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Fetch merchant's parcels
      final parcelsSnapshot = await FirebaseFirestore.instance
          .collection('parcels')
          .where('merchantId', isEqualTo: user.uid)
          .get();

      final parcels = parcelsSnapshot.docs
          .map((doc) => ParcelModel.fromFirestore(doc))
          .toList();

      // Calculate statistics
      int pending = 0;
      int inTransit = 0;
      int delivered = 0;
      double revenue = 0;

      for (var parcel in parcels) {
        // Count by status
        switch (parcel.status) {
          case ParcelStatus.pending:
          case ParcelStatus.created:
            pending++;
            break;
          case ParcelStatus.pickedUp:
          case ParcelStatus.outForDelivery:
            inTransit++;
            break;
          case ParcelStatus.delivered:
            delivered++;
            // Add to revenue if delivered this month
            if (parcel.deliveredAt != null &&
                parcel.deliveredAt!.isAfter(startOfMonth)) {
              revenue += parcel.deliveryFee;
            }
            break;
          default:
            break;
        }
      }

      // Get recent parcels (last 5)
      parcels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final recent = parcels.take(5).toList();

      setState(() {
        _pendingCount = pending;
        _inTransitCount = inTransit;
        _deliveredCount = delivered;
        _totalRevenue = revenue;
        _recentParcels = recent;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              tr.merchant_dashboard,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Quick stats cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: tr.pending,
                    value: _pendingCount.toString(),
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: tr.in_transit,
                    value: _inTransitCount.toString(),
                    icon: Icons.local_shipping,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: tr.delivered,
                    value: _deliveredCount.toString(),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildStatCard(
                    title: tr.monthly_revenue,
                    value: '\$${_totalRevenue.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: AppStyles.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent parcels section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.recent_parcels,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to parcels page
                    // This will be handled by the parent widget
                  },
                  child: Text(tr.view_all),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recent parcels list
            if (_recentParcels.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr.no_parcels_yet,
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
              ...(_recentParcels.map((parcel) => _buildParcelCard(parcel, tr))),
          ],
        ),
      ),
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
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelCard(ParcelModel parcel, S tr) {
    Color statusColor;
    String statusText;

    switch (parcel.status) {
      case ParcelStatus.pending:
      case ParcelStatus.created:
        statusColor = Colors.orange;
        statusText = tr.pending;
        break;
      case ParcelStatus.pickedUp:
      case ParcelStatus.outForDelivery:
        statusColor = Colors.blue;
        statusText = tr.in_transit;
        break;
      case ParcelStatus.delivered:
        statusColor = Colors.green;
        statusText = tr.delivered;
        break;
      case ParcelStatus.cancelled:
        statusColor = Colors.red;
        statusText = tr.cancelled;
        break;
      default:
        statusColor = Colors.grey;
        statusText = parcel.status.name;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.inventory_2, color: statusColor),
        ),
        title: Text(
          parcel.barcode,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${tr.recipient}: ${parcel.recipientName}'),
            Text('${tr.delivery_region}: ${parcel.deliveryRegion}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        isThreeLine: true,
        onTap: () {
          // Navigate to parcel details
          // TODO: Implement parcel details page
        },
      ),
    );
  }
}
