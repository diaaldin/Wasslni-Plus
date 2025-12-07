import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final ParcelModel parcel;

  const DeliveryDetailsPage({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.parcel_details),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBanner(context, tr),
            const SizedBox(height: 16),
            _buildRecipientCard(context, tr),
            const SizedBox(height: 16),
            _buildParcelInfoCard(context, tr),
            const SizedBox(height: 16),
            if (parcel.proofOfDeliveryUrl != null) ...[
              _buildImageSection(
                context,
                title: tr.proof_of_delivery,
                imageUrl: parcel.proofOfDeliveryUrl!,
              ),
              const SizedBox(height: 16),
            ],
            if (parcel.signatureUrl != null) ...[
              _buildImageSection(
                context,
                title: tr.signature,
                imageUrl: parcel.signatureUrl!,
                isSignature: true,
              ),
              const SizedBox(height: 16),
            ],
            _buildTimelineCard(context, tr),
            if (parcel.deliveryNotes != null &&
                parcel.deliveryNotes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildNotesCard(context, tr),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, S tr) {
    Color color;
    String text;
    IconData icon;

    switch (parcel.status) {
      case ParcelStatus.delivered:
        color = Colors.green;
        text = tr.delivered;
        icon = Icons.check_circle;
        break;
      case ParcelStatus.returned:
        color = Colors.orange;
        text = tr.returned;
        icon = Icons.assignment_return;
        break;
      case ParcelStatus.cancelled:
        color = Colors.red;
        text = tr.cancelled;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        text = parcel.status.toString().split('.').last;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientCard(BuildContext context, S tr) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.recipient,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildDetailRow(Icons.person, tr.name, parcel.recipientName),
            _buildDetailRow(
                Icons.phone, tr.phone_number, parcel.recipientPhone),
            _buildDetailRow(
                Icons.location_on, tr.address, parcel.deliveryAddress),
            _buildDetailRow(Icons.map, tr.region, parcel.deliveryRegion),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelInfoCard(BuildContext context, S tr) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.parcel_info,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildDetailRow(
                Icons.qr_code, tr.barcode_label(parcel.barcode), ''),
            _buildDetailRow(Icons.attach_money, tr.total_price_label,
                '₪${parcel.totalPrice.toStringAsFixed(2)}'),
            if (parcel.description != null)
              _buildDetailRow(Icons.description, tr.parcel_description,
                  parcel.description!),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context,
      {required String title,
      required String imageUrl,
      bool isSignature = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Open full screen image
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(backgroundColor: Colors.black),
                      backgroundColor: Colors.black,
                      body: Center(
                        child: Image.network(imageUrl),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: isSignature ? BoxFit.contain : BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, S tr) {
    final dateFormat = DateFormat('MMM d, yyyy h:mm a');

    // Sort history by timestamp (newest first for UI usually, or oldest first for timeline flow)
    final history = List<StatusHistory>.from(parcel.statusHistory)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.timeline,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            if (history.isEmpty) ...[
              _buildDetailRow(Icons.create, tr.created_at,
                  dateFormat.format(parcel.createdAt)),
              if (parcel.actualDeliveryTime != null)
                _buildDetailRow(Icons.check_circle_outline, tr.delivered_at,
                    dateFormat.format(parcel.actualDeliveryTime!)),
            ] else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(
                              _getStatusIcon(item.status),
                              color: AppStyles.primaryColor,
                              size: 20,
                            ),
                            if (index < history.length - 1)
                              Container(
                                width: 2,
                                height: 30,
                                color: Colors.grey[300],
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getStatusText(item.status, tr),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                dateFormat.format(item.timestamp),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              if (item.notes != null && item.notes!.isNotEmpty)
                                Text(
                                  item.notes!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.delivered:
        return Icons.check_circle;
      case ParcelStatus.returned:
        return Icons.assignment_return;
      case ParcelStatus.cancelled:
        return Icons.cancel;
      case ParcelStatus.outForDelivery:
        return Icons.local_shipping;
      case ParcelStatus.atWarehouse:
        return Icons.warehouse;
      case ParcelStatus.enRouteDistributor:
        return Icons.transfer_within_a_station;
      case ParcelStatus.readyToShip:
        return Icons.inventory_2;
      case ParcelStatus.awaitingLabel:
        return Icons.pending;
    }
  }

  String _getStatusText(ParcelStatus status, S tr) {
    switch (status) {
      case ParcelStatus.delivered:
        return tr.delivered;
      case ParcelStatus.returned:
        return tr.returned;
      case ParcelStatus.cancelled:
        return tr.cancelled;
      case ParcelStatus.outForDelivery:
        return tr.status_out_for_delivery;
      case ParcelStatus.awaitingLabel:
        return tr.status_awaiting_label;
      case ParcelStatus.readyToShip:
        return tr.status_ready_to_ship;
      case ParcelStatus.enRouteDistributor:
        return tr.status_en_route_distributor;
      case ParcelStatus.atWarehouse:
        return tr.status_at_warehouse;
    }
  }

  Widget _buildNotesCard(BuildContext context, S tr) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.notes,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text(parcel.deliveryNotes!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
