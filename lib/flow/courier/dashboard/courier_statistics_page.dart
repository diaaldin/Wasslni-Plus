import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:fl_chart/fl_chart.dart';

class CourierStatisticsPage extends StatefulWidget {
  const CourierStatisticsPage({super.key});

  @override
  State<CourierStatisticsPage> createState() => _CourierStatisticsPageState();
}

class _CourierStatisticsPageState extends State<CourierStatisticsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

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
        title: Text(tr.statistics),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: StreamBuilder<List<ParcelModel>>(
        stream: _firestoreService.streamCourierParcels(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allParcels = snapshot.data ?? [];
          final todaysParcels = _filterTodaysParcels(allParcels);
          final weekParcels = _filterWeekParcels(allParcels);
          final monthParcels = _filterMonthParcels(allParcels);

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
                  // Today's Performance Section
                  _buildSectionTitle(tr.todays_performance, Icons.today),
                  const SizedBox(height: 12),
                  _buildTodaysPerformance(todaysParcels, tr),
                  const SizedBox(height: 24),

                  // Earnings Breakdown Section
                  _buildSectionTitle(
                      tr.earnings_breakdown, Icons.monetization_on),
                  const SizedBox(height: 12),
                  _buildEarningsBreakdown(
                      todaysParcels, weekParcels, monthParcels, tr),
                  const SizedBox(height: 24),

                  // Weekly Earnings Trend
                  _buildSectionTitle(tr.earnings_trend, Icons.trending_up),
                  const SizedBox(height: 12),
                  _buildWeeklyEarningsTrend(allParcels, tr),
                  const SizedBox(height: 24),

                  // Delivery Statistics
                  _buildSectionTitle(tr.delivery_statistics, Icons.bar_chart),
                  const SizedBox(height: 12),
                  _buildDeliveryStatistics(todaysParcels, tr),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppStyles.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysPerformance(List<ParcelModel> parcels, S tr) {
    final delivered =
        parcels.where((p) => p.status == ParcelStatus.delivered).length;

    final successRate =
        parcels.isEmpty ? 0.0 : (delivered / parcels.length) * 100;
    final avgDeliveryTime = _calculateAverageDeliveryTime(parcels);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPerformanceMetric(
                    tr.delivery_success_rate,
                    '${successRate.toStringAsFixed(1)}%',
                    Icons.percent,
                    successRate >= 80 ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPerformanceMetric(
                    tr.average_delivery_time,
                    avgDeliveryTime,
                    Icons.access_time,
                    AppStyles.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Success Rate Visual Indicator
            LinearProgressIndicator(
              value: successRate / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                successRate >= 80 ? Colors.green : Colors.orange,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(
      String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsBreakdown(
    List<ParcelModel> today,
    List<ParcelModel> week,
    List<ParcelModel> month,
    S tr,
  ) {
    final todayEarnings = _calculateEarnings(today);
    final weekEarnings = _calculateEarnings(week);
    final monthEarnings = _calculateEarnings(month);

    return Column(
      children: [
        _buildEarningsCard(
          tr.earnings_today,
          todayEarnings,
          Icons.today,
          Colors.green,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEarningsCard(
                tr.this_week,
                weekEarnings,
                Icons.calendar_view_week,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEarningsCard(
                tr.this_month,
                monthEarnings,
                Icons.calendar_month,
                AppStyles.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsCard(
      String title, double amount, IconData icon, Color color) {
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₪${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyEarningsTrend(List<ParcelModel> allParcels, S tr) {
    final weeklyData = _getWeeklyEarningsData(allParcels);

    if (weeklyData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              tr.no_data_available,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₪${value.toInt()}',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final days = [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun'
                      ];
                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: weeklyData,
                  isCurved: true,
                  color: AppStyles.primaryColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppStyles.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryStatistics(List<ParcelModel> parcels, S tr) {
    final delivered =
        parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final pending = parcels
        .where((p) =>
            p.status != ParcelStatus.delivered &&
            p.status != ParcelStatus.returned &&
            p.status != ParcelStatus.cancelled)
        .length;
    final failed = parcels
        .where((p) =>
            p.status == ParcelStatus.returned ||
            p.status == ParcelStatus.cancelled)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow(tr.delivered, delivered, Colors.green),
            const Divider(),
            _buildStatRow(tr.pending, pending, Colors.orange),
            const Divider(),
            _buildStatRow(tr.failed, failed, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for filtering and calculations
  List<ParcelModel> _filterTodaysParcels(List<ParcelModel> parcels) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return parcels.where((p) {
      return p.createdAt.isAfter(todayStart) && p.createdAt.isBefore(todayEnd);
    }).toList();
  }

  List<ParcelModel> _filterWeekParcels(List<ParcelModel> parcels) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartMidnight =
        DateTime(weekStart.year, weekStart.month, weekStart.day);

    return parcels.where((p) {
      return p.createdAt.isAfter(weekStartMidnight);
    }).toList();
  }

  List<ParcelModel> _filterMonthParcels(List<ParcelModel> parcels) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    return parcels.where((p) {
      return p.createdAt.isAfter(monthStart);
    }).toList();
  }

  double _calculateEarnings(List<ParcelModel> parcels) {
    return parcels
        .where((p) => p.status == ParcelStatus.delivered)
        .fold<double>(0, (sum, p) => sum + p.deliveryFee);
  }

  String _calculateAverageDeliveryTime(List<ParcelModel> parcels) {
    final deliveredParcels = parcels
        .where((p) =>
            p.status == ParcelStatus.delivered && p.actualDeliveryTime != null)
        .toList();

    if (deliveredParcels.isEmpty) {
      return 'N/A';
    }

    final totalMinutes = deliveredParcels.fold<int>(0, (sum, p) {
      final duration = p.actualDeliveryTime!.difference(p.createdAt);
      return sum + duration.inMinutes;
    });

    final avgMinutes = totalMinutes / deliveredParcels.length;

    if (avgMinutes < 60) {
      return '${avgMinutes.toInt()} ${S.of(context).minutes}';
    } else if (avgMinutes < 1440) {
      return '${(avgMinutes / 60).toStringAsFixed(1)} ${S.of(context).hours}';
    } else {
      return '${(avgMinutes / 1440).toStringAsFixed(1)} ${S.of(context).days}';
    }
  }

  List<FlSpot> _getWeeklyEarningsData(List<ParcelModel> parcels) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final dayStart = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day + i,
      );
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayParcels = parcels.where((p) {
        return p.status == ParcelStatus.delivered &&
            p.createdAt.isAfter(dayStart) &&
            p.createdAt.isBefore(dayEnd);
      }).toList();

      final earnings = _calculateEarnings(dayParcels);
      spots.add(FlSpot(i.toDouble(), earnings));
    }

    return spots;
  }
}
