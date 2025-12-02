// parcel_detail_card.dart
import 'package:flutter/material.dart';
import 'package:wasslni_plus/flow/common/settings/parcel/parcel_progress_bar.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

class ParcelDetailCard extends StatelessWidget {
  final ParcelModel parcel;
  final VoidCallback? onTap;

  const ParcelDetailCard({
    super.key,
    required this.parcel,
    this.onTap,
  });

  String _getStatusString(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return 'بانتظار الملصق';
      case ParcelStatus.readyToShip:
        return 'جاهز للارسال';
      case ParcelStatus.enRouteDistributor:
        return 'في الطريق للموزع';
      case ParcelStatus.atWarehouse:
        return 'مخزن الموزع';
      case ParcelStatus.outForDelivery:
        return 'في الطريق للزبون';
      case ParcelStatus.delivered:
        return 'تم التوصيل';
      case ParcelStatus.returned:
        return 'طرد راجع';
      case ParcelStatus.cancelled:
        return 'ملغي';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parcel.recipientName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (parcel.barcode.isNotEmpty)
                    Text(
                      '#${parcel.barcode}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text('المنطقة: ${parcel.deliveryRegion}'),
              Text('العنوان: ${parcel.deliveryAddress}'),
              Text('السعر: ₪${parcel.totalPrice.toStringAsFixed(0)}'),
              const SizedBox(height: 12),
              ParcelProgressBar(
                currentStatus: _getStatusString(parcel.status),
                returnReason: parcel.returnReason,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
