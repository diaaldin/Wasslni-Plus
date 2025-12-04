import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  final FirestoreService _firestoreService = FirestoreService();
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = true;
  List<ParcelModel> _parcels = [];

  @override
  void initState() {
    super.initState();
    _loadMonthlyData();
  }

  Future<void> _loadMonthlyData() async {
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get all parcels for the merchant
      final allParcels = await _firestoreService.getParcelsByMerchant(user.uid);

      // Filter parcels for selected month
      _parcels = allParcels.where((parcel) {
        return parcel.createdAt.year == _selectedMonth.year &&
            parcel.createdAt.month == _selectedMonth.month;
      }).toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _changeMonth(bool next) {
    setState(() {
      if (next) {
        _selectedMonth =
            DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      } else {
        _selectedMonth =
            DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      }
    });
    _loadMonthlyData();
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.monthly_report),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Selector
                  _buildMonthSelector(tr),
                  const SizedBox(height: 24),

                  // Summary Cards
                  _buildSummaryCards(tr),
                  const SizedBox(height: 24),

                  // Delivery Statistics Chart
                  _buildDeliveryChart(tr),
                  const SizedBox(height: 24),

                  // Revenue Overview
                  _buildRevenueOverview(tr),
                  const SizedBox(height: 24),

                  // Performance Metrics
                  _buildPerformanceMetrics(tr),
                ],
              ),
            ),
    );
  }

  Widget _buildMonthSelector(S tr) {
    final monthName = _getMonthName(_selectedMonth.month);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(false),
            ),
            Text(
              '$monthName ${_selectedMonth.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(S tr) {
    final totalDeliveries = _parcels.length;
    final successfulDeliveries =
        _parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final failedDeliveries = _parcels
        .where((p) =>
            p.status == ParcelStatus.returned ||
            p.status == ParcelStatus.cancelled)
        .length;
    final pendingDeliveries =
        totalDeliveries - successfulDeliveries - failedDeliveries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.delivery_statistics,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                tr.total_deliveries,
                totalDeliveries.toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                tr.successful_deliveries,
                successfulDeliveries.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                tr.failed_deliveries,
                failedDeliveries.toString(),
                Icons.error,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                tr.pending_deliveries,
                pendingDeliveries.toString(),
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
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
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryChart(S tr) {
    final delivered =
        _parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final pending = _parcels
        .where((p) =>
            p.status == ParcelStatus.awaitingLabel ||
            p.status == ParcelStatus.readyToShip ||
            p.status == ParcelStatus.atWarehouse)
        .length;
    final inTransit = _parcels
        .where((p) =>
            p.status == ParcelStatus.enRouteDistributor ||
            p.status == ParcelStatus.outForDelivery)
        .length;
    final failed = _parcels
        .where((p) =>
            p.status == ParcelStatus.returned ||
            p.status == ParcelStatus.cancelled)
        .length;

    if (_parcels.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(child: Text('No data for this month')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.delivery_statistics,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    if (delivered > 0)
                      PieChartSectionData(
                        value: delivered.toDouble(),
                        title: '$delivered',
                        color: Colors.green,
                        radius: 50,
                      ),
                    if (pending > 0)
                      PieChartSectionData(
                        value: pending.toDouble(),
                        title: '$pending',
                        color: Colors.orange,
                        radius: 50,
                      ),
                    if (inTransit > 0)
                      PieChartSectionData(
                        value: inTransit.toDouble(),
                        title: '$inTransit',
                        color: Colors.blue,
                        radius: 50,
                      ),
                    if (failed > 0)
                      PieChartSectionData(
                        value: failed.toDouble(),
                        title: '$failed',
                        color: Colors.red,
                        radius: 50,
                      ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem('Delivered', Colors.green),
                _buildLegendItem('Pending', Colors.orange),
                _buildLegendItem('In Transit', Colors.blue),
                _buildLegendItem('Failed', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRevenueOverview(S tr) {
    final totalRevenue = _parcels
        .where((p) => p.status == ParcelStatus.delivered)
        .fold(0.0, (sum, p) => sum + p.totalPrice);

    final deliveryFees = _parcels
        .where((p) => p.status == ParcelStatus.delivered)
        .fold(0.0, (sum, p) => sum + p.deliveryFee);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.revenue_overview,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRevenueItem(tr.total_revenue, totalRevenue),
            const Divider(),
            _buildRevenueItem(tr.delivery_fees_collected, deliveryFees),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueItem(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            '₪${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(S tr) {
    final totalDeliveries = _parcels.length;
    final successfulDeliveries =
        _parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final successRate = totalDeliveries > 0
        ? (successfulDeliveries / totalDeliveries * 100)
        : 0.0;

    // Calculate average delivery time
    final deliveredParcels = _parcels
        .where((p) =>
            p.status == ParcelStatus.delivered && p.actualDeliveryTime != null)
        .toList();

    double avgDeliveryDays = 0;
    if (deliveredParcels.isNotEmpty) {
      final totalDays = deliveredParcels.fold(0.0, (sum, p) {
        final days = p.actualDeliveryTime!.difference(p.createdAt).inDays;
        return sum + days;
      });
      avgDeliveryDays = totalDays / deliveredParcels.length;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.performance_metrics,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              tr.success_rate,
              '${successRate.toStringAsFixed(1)}%',
              Icons.trending_up,
              successRate >= 80 ? Colors.green : Colors.orange,
            ),
            const Divider(),
            _buildMetricRow(
              tr.average_delivery_time,
              deliveredParcels.isEmpty
                  ? 'N/A'
                  : '${avgDeliveryDays.toStringAsFixed(1)} days',
              Icons.access_time,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
