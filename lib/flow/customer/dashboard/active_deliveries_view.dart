import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/flow/customer/tracking/tracking_page.dart';

class ActiveDeliveriesView extends StatefulWidget {
  const ActiveDeliveriesView({super.key});

  @override
  State<ActiveDeliveriesView> createState() => _ActiveDeliveriesViewState();
}

class _ActiveDeliveriesViewState extends State<ActiveDeliveriesView> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<ParcelModel>> _fetchActiveParcels(String uid) async {
    // In a real app, you might want separate streams or better methods
    // For now, get all and filter (or getParcelsByCustomer which likely does 'where customerId == uid')
    // We assume getParcelsByCustomer returns all parcels for the customer.
    final parcels = await _firestoreService.getParcelsByCustomer(uid);
    return parcels
        .where((p) =>
            p.status != ParcelStatus.delivered &&
            p.status != ParcelStatus.returned &&
            p.status != ParcelStatus.cancelled)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.active_deliveries),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: FutureBuilder<List<ParcelModel>>(
        future: _fetchActiveParcels(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('${tr.error_loading_data}: ${snapshot.error}'));
          }

          final parcels = snapshot.data ?? [];

          if (parcels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    tr.no_active_deliveries,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: parcels.length,
              itemBuilder: (context, index) {
                return _buildParcelCard(parcels[index], tr);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildParcelCard(ParcelModel parcel, S tr) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackingPage(parcel: parcel),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${parcel.barcode}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(parcel.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(parcel.status, tr),
                      style: TextStyle(
                        color: _getStatusColor(parcel.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${tr.to}: ${parcel.recipientName}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      parcel.deliveryAddress,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Estimated Delivery (Mock logic for now)
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${tr.estimated_time}: 1-2 ${tr.days}', // Placeholder
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
      case ParcelStatus.readyToShip:
        return Colors.orange;
      case ParcelStatus.atWarehouse:
        return Colors.blue;
      case ParcelStatus.outForDelivery:
      case ParcelStatus.enRouteDistributor:
        return AppStyles.primaryColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(ParcelStatus status, S tr) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return tr.status_awaiting_label; // You might need to add this key
      case ParcelStatus.readyToShip:
        return tr.status_ready_to_ship; // And this
      case ParcelStatus.atWarehouse:
        return tr.status_at_warehouse; // And this
      case ParcelStatus.enRouteDistributor:
        return tr.status_en_route_distributor; // And this
      case ParcelStatus.outForDelivery:
        return tr.status_out_for_delivery;
      default:
        return status.name;
    }
  }
}
