import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/review_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/flow/admin/couriers/courier_route_page.dart';
import 'package:intl/intl.dart';

class CourierPerformancePage extends StatefulWidget {
  final UserModel courier;

  const CourierPerformancePage({super.key, required this.courier});

  @override
  State<CourierPerformancePage> createState() => _CourierPerformancePageState();
}

class _CourierPerformancePageState extends State<CourierPerformancePage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  Map<String, dynamic>? _stats;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _firestoreService
          .getCourierPerformanceStats(widget.courier.uid ?? '');
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.courier_performance),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('${tr.error}: $_error'))
              : _stats == null
                  ? Center(child: Text(tr.no_data_available))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourierRoutePage(
                                      courier: widget.courier,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.map),
                              label: Text(tr.show_route),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: AppStyles.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            tr.metrics,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildMetricsGrid(context, tr),
                          const SizedBox(height: 24),
                          Text(
                            tr.reviews,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildReviewsList(context, tr),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppStyles.primaryColor.withValues(alpha: 0.1),
          backgroundImage: (widget.courier.profilePhotoUrl != null &&
                  widget.courier.profilePhotoUrl!.isNotEmpty)
              ? NetworkImage(widget.courier.profilePhotoUrl!)
              : null,
          child: (widget.courier.profilePhotoUrl == null ||
                  widget.courier.profilePhotoUrl!.isEmpty)
              ? const Icon(Icons.person,
                  size: 40, color: AppStyles.primaryColor)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courier.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (widget.courier.phoneNumber.isNotEmpty)
              Text(
                widget.courier.phoneNumber,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            if (widget.courier.vehicleType != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${widget.courier.vehicleType} • ${widget.courier.vehiclePlate}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context, S tr) {
    final stats = _stats!;
    final total = stats['totalAssignments'] as int? ?? 0;
    final delivered = stats['delivered'] as int? ?? 0;
    final cancelled = stats['cancelled'] as int? ?? 0;
    final avgTime = stats['avgDeliveryTime'] as double? ?? 0.0;
    final rating = stats['avgRating'] as double? ?? 0.0;

    // Safety check just in case
    final successRate = total > 0 ? (delivered / total * 100) : 0.0;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          title: tr.total_assignments,
          value: total.toString(),
          icon: Icons.assignment,
          color: Colors.blue,
        ),
        _buildStatCard(
          context,
          title: tr.success_rate,
          value: '${successRate.toStringAsFixed(1)}%',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _buildStatCard(
          context,
          title: tr.rating,
          value: rating.toStringAsFixed(1),
          icon: Icons.star,
          color: Colors.amber,
        ),
        _buildStatCard(
          context,
          title: tr.avg_delivery_time,
          value: '${avgTime.toStringAsFixed(1)} ${tr.hours}',
          icon: Icons.timer,
          color: Colors.purple,
        ),
        _buildStatCard(
          context,
          title: tr.cancelled,
          value: cancelled.toString(),
          icon: Icons.cancel,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, S tr) {
    if (_stats == null || _stats!['reviews'] == null) {
      return Center(child: Text(tr.no_reviews));
    }

    final reviews = _stats!['reviews'] as List<ReviewModel>;

    if (reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          tr.no_reviews,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber.withValues(alpha: 0.1),
              child: Text(
                review.rating.toString(),
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              DateFormat('MMM d, yyyy').format(review.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (review.comment != null && review.comment!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(review.comment!),
                  ),
                if (review.tip != null && review.tip! > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Tip: ${review.tip}',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
