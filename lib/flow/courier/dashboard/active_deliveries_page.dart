import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class ActiveDeliveriesPage extends StatefulWidget {
  const ActiveDeliveriesPage({super.key});

  @override
  State<ActiveDeliveriesPage> createState() => _ActiveDeliveriesPageState();
}

class _ActiveDeliveriesPageState extends State<ActiveDeliveriesPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.delivery_queue),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Text(tr.all),
              ),
              PopupMenuItem(
                value: 'pending',
                child: Text(tr.pending_pickup),
              ),
              PopupMenuItem(
                value: 'in_transit',
                child: Text(tr.in_transit),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<ParcelModel>>(
        stream: _firestoreService.streamCourierParcels(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allParcels = snapshot.data ?? [];

          // Filter only active deliveries (not delivered, returned, or cancelled)
          final activeParcels = allParcels.where((p) {
            final isActive = p.status != ParcelStatus.delivered &&
                p.status != ParcelStatus.returned &&
                p.status != ParcelStatus.cancelled;

            if (_filterStatus == 'all') return isActive;

            if (_filterStatus == 'pending') {
              return isActive &&
                  (p.status == ParcelStatus.awaitingLabel ||
                      p.status == ParcelStatus.readyToShip);
            }

            if (_filterStatus == 'in_transit') {
              return isActive &&
                  (p.status == ParcelStatus.outForDelivery ||
                      p.status == ParcelStatus.enRouteDistributor);
            }

            return isActive;
          }).toList();

          // Sort by priority: out for delivery first, then others
          activeParcels.sort((a, b) {
            if (a.status == ParcelStatus.outForDelivery &&
                b.status != ParcelStatus.outForDelivery) {
              return -1;
            }
            if (a.status != ParcelStatus.outForDelivery &&
                b.status == ParcelStatus.outForDelivery) {
              return 1;
            }
            return a.createdAt.compareTo(b.createdAt);
          });

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: activeParcels.isEmpty
                ? _buildEmptyState(tr)
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeParcels.length,
                    onReorder: (oldIndex, newIndex) {
                      // In a real app, you might want to save the order preference
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = activeParcels.removeAt(oldIndex);
                        activeParcels.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final parcel = activeParcels[index];
                      return _buildDeliveryCard(
                        parcel,
                        index + 1,
                        tr,
                        key: ValueKey(parcel.id),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(S tr) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              tr.no_active_deliveries,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr.all_caught_up,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(
    ParcelModel parcel,
    int queuePosition,
    S tr, {
    required Key key,
  }) {
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showDeliveryDetails(parcel, tr),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Queue Position Badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppStyles.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$queuePosition',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Barcode and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${parcel.barcode}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusChip(parcel.status, tr),
                      ],
                    ),
                  ),
                  // Drag Handle
                  Icon(
                    Icons.drag_handle,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const Divider(height: 24),

              // Recipient Info
              _buildInfoRow(
                Icons.person_outline,
                tr.recipient,
                parcel.recipientName,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.phone_outlined,
                tr.phone_number,
                parcel.recipientPhone,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.location_on_outlined,
                tr.address,
                parcel.deliveryAddress,
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _callRecipient(parcel),
                      icon: const Icon(Icons.call, size: 18),
                      label: Text(tr.call),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppStyles.primaryColor,
                        side: BorderSide(color: AppStyles.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _navigate(parcel),
                      icon: const Icon(Icons.navigation, size: 18),
                      label: Text(tr.navigate),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
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

  Widget _buildStatusChip(ParcelStatus status, S tr) {
    Color color;
    String text;

    switch (status) {
      case ParcelStatus.awaitingLabel:
      case ParcelStatus.readyToShip:
        color = Colors.orange;
        text = tr.pending_pickup;
        break;
      case ParcelStatus.atWarehouse:
        color = Colors.blue;
        text = 'At Warehouse';
        break;
      case ParcelStatus.outForDelivery:
      case ParcelStatus.enRouteDistributor:
        color = AppStyles.primaryColor;
        text = tr.in_transit;
        break;
      default:
        color = Colors.grey;
        text = status.toString();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeliveryDetails(ParcelModel parcel, S tr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  '${tr.parcel_details} #${parcel.barcode}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Status
                _buildStatusChip(parcel.status, tr),
                const SizedBox(height: 24),

                // Recipient Details
                _buildDetailSection(
                  tr.recipient,
                  [
                    _buildDetailRow(tr.name, parcel.recipientName),
                    _buildDetailRow(tr.phone_number, parcel.recipientPhone),
                    if (parcel.recipientAltPhone != null &&
                        parcel.recipientAltPhone!.isNotEmpty)
                      _buildDetailRow(tr.alt_phone, parcel.recipientAltPhone!),
                  ],
                ),
                const SizedBox(height: 16),

                // Delivery Details
                _buildDetailSection(
                  tr.delivery_location,
                  [
                    _buildDetailRow(tr.address, parcel.deliveryAddress),
                    _buildDetailRow(tr.region, parcel.deliveryRegion),
                  ],
                ),
                const SizedBox(height: 16),

                // Parcel Details
                _buildDetailSection(
                  tr.parcel_info,
                  [
                    _buildDetailRow(
                        tr.parcel_description, parcel.description ?? 'N/A'),
                    _buildDetailRow(
                      tr.delivery_fee,
                      '₪${parcel.deliveryFee.toStringAsFixed(2)}',
                    ),
                    if (parcel.deliveryInstructions != null &&
                        parcel.deliveryInstructions!.isNotEmpty)
                      _buildDetailRow(
                        tr.delivery_instructions,
                        parcel.deliveryInstructions!,
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _callRecipient(parcel);
                        },
                        icon: const Icon(Icons.call),
                        label: Text(tr.call),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppStyles.primaryColor,
                          side: BorderSide(color: AppStyles.primaryColor),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigate(parcel);
                        },
                        icon: const Icon(Icons.navigation),
                        label: Text(tr.navigate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callRecipient(ParcelModel parcel) {
    // In production, this would use url_launcher to make a phone call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${S.of(context).call} ${parcel.recipientPhone}'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _navigate(ParcelModel parcel) {
    // In production, this would open Google Maps or Waze
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${S.of(context).navigate} to ${parcel.deliveryAddress}'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
