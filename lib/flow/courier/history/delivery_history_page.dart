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
          final historyParcels = parcels.where((p) {
            return p.status == ParcelStatus.delivered ||
                p.status == ParcelStatus.returned ||
                p.status == ParcelStatus.cancelled;
          }).toList();

          // Sort by date descending (newest first)
          historyParcels.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (historyParcels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    tr.no_history_found,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyParcels.length,
            itemBuilder: (context, index) {
              final parcel = historyParcels[index];
              return _buildHistoryCard(parcel, tr);
            },
          );
        },
      ),
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
