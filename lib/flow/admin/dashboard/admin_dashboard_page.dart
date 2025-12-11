import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.analytics),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: tr.export,
            onPressed: () {
              // TODO: Implement export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(tr.coming_soon)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder<List<ParcelModel>>(
        stream: _firestoreService.streamAllParcels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${tr.error}: ${snapshot.error}'));
          }

          final parcels = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(context, parcels),
                const SizedBox(height: 24),
                _buildChartsSection(context, parcels),
                const SizedBox(height: 24),
                _buildRegionalBreakdown(context, parcels),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, List<ParcelModel> parcels) {
    final tr = S.of(context);
    final totalParcels = parcels.length;

    // Calculate Total Revenue (sum of totalPrice for delivered parcels)
    // Assuming 'delivered' status means money is collected/verified.
    // Or maybe shipping fees? Let's use totalPrice for now as "Revenue" in a loose sense,
    // or deliveryFee if we strictly mean company revenue. Let's use deliveryFee for Admin view.
    final totalRevenue = parcels
        .where((p) => p.status == ParcelStatus.delivered)
        .fold(0.0, (sum, p) => sum + p.deliveryFee);

    // Calculate Success Rate
    final completedParcels = parcels
        .where((p) =>
            p.status == ParcelStatus.delivered ||
            p.status == ParcelStatus.returned ||
            p.status == ParcelStatus.cancelled)
        .length;

    final successfulParcels =
        parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final successRate = completedParcels > 0
        ? (successfulParcels / completedParcels * 100).toStringAsFixed(1)
        : '0.0';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return isWide
            ? Row(
                children: [
                  Expanded(
                      child: _buildMetricCard(
                          tr.total_revenue,
                          '${totalRevenue.toStringAsFixed(2)} ₪',
                          Icons.attach_money,
                          Colors.green)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildMetricCard(
                          tr.total_parcels,
                          totalParcels.toString(),
                          Icons.local_shipping,
                          Colors.blue)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildMetricCard(tr.success_rate, '$successRate%',
                          Icons.check_circle, Colors.orange)),
                ],
              )
            : Column(
                children: [
                  _buildMetricCard(
                      tr.total_revenue,
                      '${totalRevenue.toStringAsFixed(2)} ₪',
                      Icons.attach_money,
                      Colors.green),
                  const SizedBox(height: 16),
                  _buildMetricCard(tr.total_parcels, totalParcels.toString(),
                      Icons.local_shipping, Colors.blue),
                  const SizedBox(height: 16),
                  _buildMetricCard(tr.success_rate, '$successRate%',
                      Icons.check_circle, Colors.orange),
                ],
              );
      },
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context, List<ParcelModel> parcels) {
    final tr = S.of(context);

    // Process data for Pie Chart (Status Distribution)
    final statusCounts = <ParcelStatus, int>{};
    for (var p in parcels) {
      statusCounts[p.status] = (statusCounts[p.status] ?? 0) + 1;
    }

    final List<PieChartSectionData> pieSections = [];
    statusCounts.forEach((status, count) {
      final color = _getStatusColor(status);
      final percentage = (count / parcels.length * 100);

      if (percentage > 5) {
        // Only show significant slices to avoid clutter
        pieSections.add(
          PieChartSectionData(
            color: color,
            value: count.toDouble(),
            title: '${percentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.delivery_statistics,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ParcelStatus.values.map((status) {
        if (status == ParcelStatus.awaitingLabel ||
            status == ParcelStatus.enRouteDistributor ||
            status == ParcelStatus.delivered ||
            status == ParcelStatus.cancelled) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status.name
                      .replaceAll(RegExp(r'(?=[A-Z])'), ' ')
                      .toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Color _getStatusColor(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return Colors.grey;
      case ParcelStatus.readyToShip:
        return Colors.blueGrey;
      case ParcelStatus.enRouteDistributor: // Formerly in_transit logic
        return Colors.blue;
      case ParcelStatus.atWarehouse:
        return Colors.orange;
      case ParcelStatus.outForDelivery:
        return Colors.indigo;
      case ParcelStatus.delivered:
        return Colors.green;
      case ParcelStatus.returned:
        return Colors.red;
      case ParcelStatus.cancelled:
        return Colors.black54;
    }
  }

  Widget _buildRegionalBreakdown(
      BuildContext context, List<ParcelModel> parcels) {
    final tr = S.of(context);
    final regionCounts = <String, int>{};

    for (var p in parcels) {
      if (p.deliveryRegion.isNotEmpty) {
        regionCounts[p.deliveryRegion] =
            (regionCounts[p.deliveryRegion] ?? 0) + 1;
      }
    }

    final sortedRegions = regionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.delivery_region,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...sortedRegions.take(5).map((entry) {
              final percentage = (entry.value / parcels.length);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        Text(
                            '${entry.value} (${(percentage * 100).toStringAsFixed(1)}%)'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppStyles.primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
