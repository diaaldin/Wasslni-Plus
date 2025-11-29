// parcel_detail_card.dart
import 'package:flutter/material.dart';
import 'package:turoudi/flow/common/settings/parcel/parcel_progress_bar.dart';

class ParcelDetailCard extends StatelessWidget {
  final Map<String, dynamic> parcel;

  const ParcelDetailCard({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parcel['recipient'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text('المنطقة: ${parcel['region']}'),
            Text('العنوان: ${parcel['location']}'),
            Text('السعر: ₪${parcel['cost']}'),
            const SizedBox(height: 12),
            ParcelProgressBar(
              currentStatus: parcel['status'],
              returnReason: parcel['returnReason'],
            ),
          ],
        ),
      ),
    );
  }
}
