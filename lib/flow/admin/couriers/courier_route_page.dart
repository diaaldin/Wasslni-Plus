import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CourierRoutePage extends StatefulWidget {
  final UserModel courier;

  const CourierRoutePage({super.key, required this.courier});

  @override
  State<CourierRoutePage> createState() => _CourierRoutePageState();
}

class _CourierRoutePageState extends State<CourierRoutePage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<ParcelModel> _parcels = [];
  bool _isLoading = true;
  bool _isOptimized = false;

  @override
  void initState() {
    super.initState();
    _loadParcels();
  }

  Future<void> _loadParcels() async {
    try {
      final parcels = await _firestoreService.getParcelsByCourier(
          widget.courier.uid ??
              ''); // This actually fetches ALL including delivered.

      // Filter for active parcels only
      final activeParcels = parcels.where((p) {
        return p.status == ParcelStatus.readyToShip ||
            p.status == ParcelStatus.enRouteDistributor ||
            p.status == ParcelStatus.atWarehouse ||
            p.status == ParcelStatus.outForDelivery;
      }).toList();

      if (mounted) {
        setState(() {
          _parcels = activeParcels;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading parcels: $e')),
        );
      }
    }
  }

  void _optimizeRoute() {
    setState(() {
      _parcels.sort((a, b) {
        // Primary sort: Region
        int regionCompare = a.deliveryRegion.compareTo(b.deliveryRegion);
        if (regionCompare != 0) return regionCompare;

        // Secondary sort: Address (lexicographical proxy for location)
        return a.deliveryAddress.compareTo(b.deliveryAddress);
      });
      _isOptimized = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).route_optimized),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _shareRoute() async {
    final tr = S.of(context);
    final StringBuffer sb = StringBuffer();
    sb.writeln('*${tr.my_route} - ${widget.courier.name}*');
    sb.writeln('----------------');

    for (int i = 0; i < _parcels.length; i++) {
      final p = _parcels[i];
      sb.writeln('${i + 1}. [${p.deliveryRegion}] ${p.deliveryAddress}');
      sb.writeln('   Has: #${p.barcode}');
      sb.writeln('');
    }

    final String text = sb.toString();
    final Uri url =
        Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Fallback for web or if whatsapp not installed - maybe share sheet?
      // But for now show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${tr.route_map} - ${widget.courier.name}'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isOptimized ? Icons.check_circle : Icons.auto_graph),
            tooltip: tr.optimized_route,
            onPressed: _optimizeRoute,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _parcels.isEmpty ? null : _shareRoute,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _parcels.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        tr.no_active_deliveries,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _parcels.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final ParcelModel item = _parcels.removeAt(oldIndex);
                      _parcels.insert(newIndex, item);
                      _isOptimized = false; // Manually changed
                    });
                  },
                  itemBuilder: (context, index) {
                    final parcel = _parcels[index];
                    return Card(
                      key: ValueKey(parcel.id ?? parcel.barcode),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppStyles.primaryColor.withOpacity(0.1),
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              color: AppStyles.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          parcel.recipientName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${parcel.deliveryRegion} - ${parcel.deliveryAddress}',
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tr.status_label(
                                  _getStatusText(context, parcel.status)),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppStyles.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        trailing:
                            const Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    );
                  },
                ),
    );
  }

  String _getStatusText(BuildContext context, ParcelStatus status) {
    final tr = S.of(context);
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return tr.status_awaiting_label;
      case ParcelStatus.readyToShip:
        return tr.status_ready_to_ship;
      case ParcelStatus.enRouteDistributor:
        return tr.status_en_route_distributor;
      case ParcelStatus.atWarehouse:
        return tr.status_at_warehouse;
      case ParcelStatus.outForDelivery:
        return tr.status_out_for_delivery;
      case ParcelStatus.delivered:
        return tr.status_delivered;
      case ParcelStatus.returned:
        return tr.status_returned;
      case ParcelStatus.cancelled:
        return tr.status_cancelled;
    }
  }
}
