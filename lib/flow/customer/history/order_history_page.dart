import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/flow/customer/tracking/tracking_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<ParcelModel>> _fetchHistoryParcels(String uid) async {
    final parcels = await _firestoreService.getParcelsByCustomer(uid);
    return parcels
        .where((p) =>
            p.status == ParcelStatus.delivered ||
            p.status == ParcelStatus.returned ||
            p.status == ParcelStatus.cancelled)
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
        title: Text(tr.parcels),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: FutureBuilder<List<ParcelModel>>(
        future: _fetchHistoryParcels(user.uid),
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
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(tr.no_history_found,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: parcels.length,
            itemBuilder: (context, index) {
              return _buildHistoryCard(parcels[index], tr);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(ParcelModel parcel, S tr) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => TrackingPage(parcel: parcel)));
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
                  _buildStatusChip(parcel.status, tr),
                ],
              ),
              const SizedBox(height: 12),
              Text('${tr.to}: ${parcel.recipientName}'),
              const SizedBox(height: 6),
              Text(parcel.deliveryAddress,
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 8),
              Text(
                  '${tr.updated_at}: ${parcel.updatedAt.day}/${parcel.updatedAt.month}/${parcel.updatedAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ParcelStatus status, S tr) {
    Color color;
    String text;

    switch (status) {
      case ParcelStatus.delivered:
        color = Colors.green;
        text = tr.delivered;
        break;
      case ParcelStatus.returned:
        color = Colors.red;
        text = tr.returned;
        break;
      case ParcelStatus.cancelled:
        color = Colors.grey;
        text = tr.cancelled;
        break;
      default:
        color = AppStyles.primaryColor;
        text = status.name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
