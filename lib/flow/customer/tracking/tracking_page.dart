import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/flow/customer/feedback/delivery_feedback_page.dart';

class TrackingPage extends StatefulWidget {
  final ParcelModel parcel;
  const TrackingPage({super.key, required this.parcel});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  LatLng _center = const LatLng(31.7683, 35.2137); // Default to Jerusalem

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    try {
      // 1. Geocode Delivery Address
      List<Location> locations = await locationFromAddress(
          '${widget.parcel.deliveryAddress}, Palestine');

      if (locations.isNotEmpty) {
        final dest =
            LatLng(locations.first.latitude, locations.first.longitude);
        _center = dest;

        _markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: dest,
          infoWindow: InfoWindow(
            title: widget.parcel.recipientName,
            snippet: widget.parcel.deliveryAddress,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }

      // 2. Add Courier/Current Location if available (Mock logic for now as we don't stream live courier loc)
      // If status is OutForDelivery, we might simulate a position nearby or just show the destination.
    } catch (e) {
      debugPrint("Error loading map data: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.parcel_details),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 14,
                    ),
                    markers: _markers,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
          ),
          _buildTrackingSheet(tr),
        ],
      ),
    );
  }

  Widget _buildTrackingSheet(S tr) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and ETA
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppStyles.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping,
                    color: AppStyles.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(widget.parcel.status, tr),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${tr.estimated_time}: 1-2 ${tr.days}', // Placeholder logic
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const SizedBox(height: 24),

          // Timeline
          Text(tr.timeline,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.parcel.statusHistory.length,
            itemBuilder: (context, index) {
              // Show latest first? Usually timeline is bottom-up or top-down.
              // Let's show reverse (latest first) or as is if already sorted.
              // Helper sorts by descending in FirestoreService? No, it's array.
              // Usually appends. So last is latest.
              // Let's reverse it visually.
              final history = widget.parcel.statusHistory[
                  widget.parcel.statusHistory.length - 1 - index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? AppStyles.primaryColor
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (index < widget.parcel.statusHistory.length - 1)
                        Container(
                            width: 2, height: 40, color: Colors.grey[300]),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getStatusText(history.status, tr),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            '${history.timestamp.day}/${history.timestamp.month} ${history.timestamp.hour}:${history.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                          if (history.notes != null &&
                              history.notes!.isNotEmpty)
                            Text(history.notes!,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          if (widget.parcel.courierId != null) ...[
            const Divider(),
            const SizedBox(height: 16),
            FutureBuilder<UserModel?>(
              future: FirestoreService().getUser(widget.parcel.courierId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final courier = snapshot.data!;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: courier.profilePhotoUrl != null
                          ? NetworkImage(courier.profilePhotoUrl!)
                          : null,
                      backgroundColor: Colors.grey,
                      child: courier.profilePhotoUrl == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.courier,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                          Text(
                            courier.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    if (courier.phoneNumber.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        onPressed: () {
                          launchUrl(Uri.parse('tel:${courier.phoneNumber}'));
                        },
                      ),
                  ],
                );
              },
            ),
          ],

          if (widget.parcel.status == ParcelStatus.delivered &&
              widget.parcel.proofOfDeliveryUrl != null) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(tr.proof_of_delivery,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(widget.parcel.proofOfDeliveryUrl!,
                  height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          ],

          // Leave Feedback Button (for delivered parcels)
          if (widget.parcel.status == ParcelStatus.delivered) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DeliveryFeedbackPage(parcel: widget.parcel),
                    ),
                  );
                },
                icon: const Icon(Icons.star_outline),
                label: Text(tr.leave_feedback),
                style: FilledButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText(ParcelStatus status, S tr) {
    // Reuse logic or better, have a shared util.
    // For now simple switch
    switch (status) {
      case ParcelStatus.outForDelivery:
        return tr.status_out_for_delivery;
      case ParcelStatus.delivered:
        return tr.delivered;
      default:
        return status.name;
    }
  }
}
