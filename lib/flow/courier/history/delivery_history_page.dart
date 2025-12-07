import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/flow/courier/history/delivery_details_page.dart';

class DeliveryHistoryPage extends StatefulWidget {
  const DeliveryHistoryPage({super.key});

  @override
  State<DeliveryHistoryPage> createState() => _DeliveryHistoryPageState();
}

class _DeliveryHistoryPageState extends State<DeliveryHistoryPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: now,
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyles.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text(tr.error_loading_data)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.delivery_history),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          if (_selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.filter_list_off),
              tooltip: tr.clear_selection,
              onPressed: _clearFilter,
            ),
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: tr.date_range,
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: StreamBuilder<List<ParcelModel>>(
        stream: _firestoreService.streamCourierParcels(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('${tr.error_loading_data}: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final parcels = snapshot.data ?? [];
          var historyParcels = parcels.where((p) {
            return p.status == ParcelStatus.delivered ||
                p.status == ParcelStatus.returned ||
                p.status == ParcelStatus.cancelled;
          }).toList();

          // Apply Date Filter
          if (_selectedDateRange != null) {
            historyParcels = historyParcels.where((p) {
              final date = p.createdAt;
              return date.isAfter(_selectedDateRange!.start
                      .subtract(const Duration(seconds: 1))) &&
                  date.isBefore(
                      _selectedDateRange!.end.add(const Duration(days: 1)));
            }).toList();
          }

          // Sort by date descending (newest first)
          historyParcels.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Calculate Earnings
          double totalEarnings = 0;
          int deliveredCount = 0;
          for (var p in historyParcels) {
            if (p.status == ParcelStatus.delivered) {
              totalEarnings += p.deliveryFee;
              deliveredCount++;
            }
          }

          return Column(
            children: [
              if (_selectedDateRange != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt,
                          size: 16, color: AppStyles.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                        style: TextStyle(
                          color: AppStyles.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: _clearFilter,
                        child: Icon(Icons.close, size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // Summary Card
              _buildSummaryCard(totalEarnings, deliveredCount, tr),

              Expanded(
                child: historyParcels.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _selectedDateRange != null
                                  ? tr.no_parcels_yet
                                  : tr.no_history_found,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            ),
                            if (_selectedDateRange != null)
                              TextButton(
                                onPressed: _clearFilter,
                                child: Text(tr.clear_selection),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: historyParcels.length,
                        itemBuilder: (context, index) {
                          final parcel = historyParcels[index];
                          return _buildHistoryCard(parcel, tr);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(double earnings, int count, S tr) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(tr.total_deliveries, count.toString(),
              Icons.local_shipping, Colors.white),
          Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
          _buildSummaryItem(
              tr.total_earnings,
              '₪${earnings.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.white),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(ParcelModel parcel, S tr) {
    Color statusColor;
    String statusText;

    switch (parcel.status) {
      case ParcelStatus.delivered:
        statusColor = Colors.green;
        statusText = tr.delivered;
        break;
      case ParcelStatus.returned:
        statusColor = Colors.orange;
        statusText = tr.returned;
        break;
      case ParcelStatus.cancelled:
        statusColor = Colors.red;
        statusText = tr.cancelled;
        break;
      default:
        statusColor = Colors.grey;
        statusText = parcel.status.toString().split('.').last;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailsPage(parcel: parcel),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parcel.barcode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    parcel.recipientName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      parcel.deliveryAddress,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy h:mm a').format(parcel.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    '₪${parcel.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
