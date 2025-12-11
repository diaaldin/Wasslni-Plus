import 'package:flutter/material.dart';
import 'package:wasslni_plus/flow/admin/parcels/assign_courier_dialog.dart';
import 'package:wasslni_plus/flow/common/settings/parcel/parcel_details_card.dart';
import 'package:wasslni_plus/flow/merchant/parcel/parcel_details_page.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class AdminParcelsPage extends StatefulWidget {
  const AdminParcelsPage({super.key});

  @override
  State<AdminParcelsPage> createState() => _AdminParcelsPageState();
}

class _AdminParcelsPageState extends State<AdminParcelsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestoreService = FirestoreService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ParcelModel> _filterParcels(List<ParcelModel> parcels, String type) {
    return parcels.where((parcel) {
      // Filter by search query
      final matchesSearch = parcel.recipientName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          parcel.barcode.contains(_searchQuery);

      if (!matchesSearch) return false;

      // Filter by tab type
      if (type == 'unassigned') {
        return parcel.courierId == null || parcel.courierId!.isEmpty;
      } else if (type == 'assigned') {
        return parcel.courierId != null && parcel.courierId!.isNotEmpty;
      }
      return true; // 'all'
    }).toList();
  }

  Future<void> _showAssignDialog(ParcelModel parcel) async {
    if (parcel.id == null) return;
    await showDialog<bool>(
      context: context,
      builder: (context) => AssignCourierDialog(parcelId: parcel.id!),
    );
    // If assigned, the stream will update automatically
  }

  Widget buildParcelList(List<ParcelModel> parcels, bool showAssignButton) {
    final tr = S.of(context);

    if (parcels.isEmpty) {
      return Center(child: Text(tr.no_results_found));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: parcels.length,
      itemBuilder: (context, index) {
        final parcel = parcels[index];
        return Column(
          children: [
            ParcelDetailCard(
              parcel: parcel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParcelDetailsPage(parcel: parcel),
                  ),
                );
              },
            ),
            if (showAssignButton)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: Text(tr.assign_courier),
                    onPressed: () => _showAssignDialog(parcel),
                  ),
                ),
              ),
            if (!showAssignButton) const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.parcels),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: tr.unassigned),
            Tab(text: tr.assigned),
            Tab(text: tr.all),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: tr.general_serach_hint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ParcelModel>>(
              stream: _firestoreService.streamAllParcels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('${tr.error}: ${snapshot.error}'));
                }

                final allParcels = snapshot.data ?? [];

                return TabBarView(
                  controller: _tabController,
                  children: [
                    buildParcelList(
                        _filterParcels(allParcels, 'unassigned'), true),
                    buildParcelList(_filterParcels(allParcels, 'assigned'),
                        false), // Maybe allowing re-assign?
                    buildParcelList(_filterParcels(allParcels, 'all'), false),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
