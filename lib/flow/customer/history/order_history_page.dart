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
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  ParcelStatus? _selectedStatusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<ParcelModel>> _fetchHistoryParcels(String uid) async {
    final parcels = await _firestoreService.getParcelsByCustomer(uid);
    return parcels
        .where((p) =>
            p.status == ParcelStatus.delivered ||
            p.status == ParcelStatus.returned ||
            p.status == ParcelStatus.cancelled)
        .toList();
  }

  List<ParcelModel> _filterParcels(List<ParcelModel> parcels) {
    var filtered = parcels;

    // Filter by status
    if (_selectedStatusFilter != null) {
      filtered =
          filtered.where((p) => p.status == _selectedStatusFilter).toList();
    }

    // Filter by search query (barcode or recipient name)
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        final query = _searchQuery.toLowerCase();
        return p.barcode.toLowerCase().contains(query) ||
            p.recipientName.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
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
        title: Text(tr.order_history),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: tr.search_by_barcode_or_name,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: Text(tr.all),
                  selected: _selectedStatusFilter == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = null;
                    });
                  },
                  selectedColor: AppStyles.primaryColor.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(tr.delivered),
                  selected: _selectedStatusFilter == ParcelStatus.delivered,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter =
                          selected ? ParcelStatus.delivered : null;
                    });
                  },
                  selectedColor: Colors.green.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(tr.returned),
                  selected: _selectedStatusFilter == ParcelStatus.returned,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter =
                          selected ? ParcelStatus.returned : null;
                    });
                  },
                  selectedColor: Colors.red.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(tr.cancelled),
                  selected: _selectedStatusFilter == ParcelStatus.cancelled,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter =
                          selected ? ParcelStatus.cancelled : null;
                    });
                  },
                  selectedColor: Colors.grey.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Parcels List
          Expanded(
            child: FutureBuilder<List<ParcelModel>>(
              future: _fetchHistoryParcels(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('${tr.error_loading_data}: ${snapshot.error}'));
                }

                final allParcels = snapshot.data ?? [];
                final filteredParcels = _filterParcels(allParcels);

                if (filteredParcels.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty ||
                                  _selectedStatusFilter != null
                              ? tr.no_results_found
                              : tr.no_history_found,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredParcels.length,
                  itemBuilder: (context, index) {
                    return _buildHistoryCard(filteredParcels[index], tr);
                  },
                );
              },
            ),
          ),
        ],
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
              const SizedBox(height: 12),
              // Reorder button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showReorderDialog(parcel, tr),
                  icon: const Icon(Icons.replay, size: 18),
                  label: Text(tr.reorder),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppStyles.primaryColor,
                    side: const BorderSide(color: AppStyles.primaryColor),
                  ),
                ),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Future<void> _showReorderDialog(ParcelModel parcel, S tr) async {
    // Fetch merchant details
    final merchant = await _firestoreService.getUser(parcel.merchantId);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.replay, color: AppStyles.primaryColor),
            const SizedBox(width: 8),
            Text(tr.reorder_parcel),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.original_order_details,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                  Icons.person, tr.recipient_name, parcel.recipientName),
              _buildDetailRow(
                  Icons.phone, tr.recipient_phone, parcel.recipientPhone),
              _buildDetailRow(
                  Icons.location_on, tr.address, parcel.deliveryAddress),
              _buildDetailRow(Icons.public, tr.region, parcel.deliveryRegion),
              if (parcel.parcelPrice > 0)
                _buildDetailRow(Icons.attach_money, tr.parcel_price,
                    '₪${parcel.parcelPrice}'),
              const Divider(height: 24),
              Text(
                tr.merchant_info,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              if (merchant != null) ...[
                _buildDetailRow(Icons.store, tr.merchant, merchant.name),
                if (merchant.phoneNumber.isNotEmpty)
                  _buildDetailRow(
                      Icons.phone, tr.phone_number, merchant.phoneNumber),
              ] else
                Text(
                  tr.merchant_info_unavailable,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tr.reorder_instructions,
                        style: TextStyle(color: Colors.blue[700], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.cancel),
          ),
          if (merchant != null && merchant.phoneNumber.isNotEmpty)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _callMerchant(merchant.phoneNumber);
              },
              icon: const Icon(Icons.phone, size: 18),
              label: Text(tr.call_merchant),
              style: FilledButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
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

  void _callMerchant(String phoneNumber) async {
    // Note: url_launcher package would be needed to actually make the call
    // For now, we'll show a snackbar with the number
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).call}: $phoneNumber'),
          action: SnackBarAction(
            label: S.of(context).copy_number,
            onPressed: () {
              // Copy to clipboard would go here with flutter/services
            },
          ),
        ),
      );
    }
  }
}
