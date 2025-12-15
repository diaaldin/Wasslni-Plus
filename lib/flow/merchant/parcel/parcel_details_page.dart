import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/flow/common/settings/parcel/parcel_progress_bar.dart';
import 'package:wasslni_plus/flow/merchant/parcel/add_paracel_page.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/widgets/fields/read_only_field.dart';
import 'package:wasslni_plus/services/print_label_service.dart';
import 'package:wasslni_plus/services/settings_service.dart';
import 'package:wasslni_plus/flow/admin/parcels/assign_courier_dialog.dart';

class ParcelDetailsPage extends StatelessWidget {
  final ParcelModel parcel;

  const ParcelDetailsPage({super.key, required this.parcel});

  String _getStatusString(BuildContext context, ParcelStatus status) {
    final tr = S.of(context);
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return tr.pending;
      case ParcelStatus.readyToShip:
        return 'Ready to Ship';
      case ParcelStatus.enRouteDistributor:
        return 'En Route to Distributor';
      case ParcelStatus.atWarehouse:
        return 'At Warehouse';
      case ParcelStatus.outForDelivery:
        return tr.in_transit;
      case ParcelStatus.delivered:
        return tr.delivered;
      case ParcelStatus.returned:
        return 'Returned';
      case ParcelStatus.cancelled:
        return tr.cancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcel Details'),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          // Print menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.print),
            onSelected: (value) async {
              if (value == 'label') {
                await PrintLabelService.printShippingLabel(parcel);
              } else if (value == 'receipt') {
                await PrintLabelService.printReceipt(parcel);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'label',
                child: Row(
                  children: [
                    const Icon(Icons.label_outline),
                    const SizedBox(width: 8),
                    Text(tr.print_label),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'receipt',
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long),
                    const SizedBox(width: 8),
                    Text(tr.print_receipt),
                  ],
                ),
              ),
            ],
          ),
          if (parcel.status != ParcelStatus.delivered &&
              parcel.status != ParcelStatus.cancelled &&
              parcel.status != ParcelStatus.returned)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddParcelPage(parcel: parcel),
                  ),
                );
              },
            ),
          // Assign Courier button (only for merchant admins)
          StreamBuilder<bool>(
            stream: SettingsService().merchantAdminStream,
            builder: (context, snapshot) {
              final isMerchantAdmin = snapshot.data ?? false;

              // Only show for merchant admins
              if (!isMerchantAdmin) return const SizedBox.shrink();

              // Don't show if parcel is delivered/cancelled/returned
              if (parcel.status == ParcelStatus.delivered ||
                  parcel.status == ParcelStatus.cancelled ||
                  parcel.status == ParcelStatus.returned) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: const Icon(Icons.person_add),
                tooltip: 'Assign Courier',
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AssignCourierDialog(
                      parcelId: parcel.id!,
                    ),
                  );
                  if (result == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Summary
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status: ${_getStatusString(context, parcel.status)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (parcel.barcode.isNotEmpty)
                          Text(
                            '#${parcel.barcode}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ParcelProgressBar(
                      currentStatus: _getStatusString(context, parcel.status),
                      returnReason: parcel.returnReason,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recipient Info
            Text(tr.recipient_name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ReadOnlyField(
                        label: tr.recipient_name, value: parcel.recipientName),
                    ReadOnlyField(
                        label: tr.recipient_phone,
                        value: parcel.recipientPhone),
                    if (parcel.recipientAltPhone != null)
                      ReadOnlyField(
                          label: tr.alt_phone,
                          value: parcel.recipientAltPhone!),
                    ReadOnlyField(
                        label: tr.address, value: parcel.deliveryAddress),
                    ReadOnlyField(
                        label: tr.region, value: parcel.deliveryRegion),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Price Info
            Text(tr.parcel_price,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ReadOnlyField(
                        label: tr.parcel_price,
                        value: '${parcel.parcelPrice} ₪'),
                    ReadOnlyField(
                        label: 'Delivery Fee',
                        value: '${parcel.deliveryFee} ₪'),
                    const Divider(),
                    ReadOnlyField(
                        label: tr.total_price_label,
                        value: '${parcel.totalPrice} ₪'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Timeline / History
            const Text('History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: parcel.statusHistory.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  // Show newest first
                  final history = parcel
                      .statusHistory[parcel.statusHistory.length - 1 - index];
                  return ListTile(
                    leading: const Icon(Icons.history,
                        color: AppStyles.primaryColor),
                    title: Text(_getStatusString(context, history.status)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateFormat.format(history.timestamp)),
                        if (history.notes != null && history.notes!.isNotEmpty)
                          Text('Note: ${history.notes}'),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (parcel.failureReason != null) ...[
              const SizedBox(height: 16),
              const Text('Cancellation Reason',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              const SizedBox(height: 8),
              Card(
                color: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(parcel.failureReason!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
