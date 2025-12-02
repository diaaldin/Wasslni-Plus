import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wasslni_plus/flow/common/settings/parcel/parcel_details_card.dart';
import 'package:wasslni_plus/flow/merchant/parcel/add_paracel_page.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class MerchantParcelsPage extends StatefulWidget {
  const MerchantParcelsPage({super.key});

  @override
  State<MerchantParcelsPage> createState() => _MerchantParcelsPageState();
}

class _MerchantParcelsPageState extends State<MerchantParcelsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestoreService = FirestoreService();
  String searchQuery = '';
  String? selectedRegion;
  String? selectedStatus;

  final List<String> regions = ['الداخل', 'القدس', 'الضفة'];
  final List<String> statuses = [
    'بانتظار الملصق',
    'جاهز للارسال',
    'في الطريق للموزع',
    'مخزن الموزع',
    'في الطريق للزبون',
    'تم التوصيل',
    'طرد راجع',
    'ملغي',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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

  List<ParcelModel> _filterParcels(List<ParcelModel> parcels) {
    return parcels.where((parcel) {
      final statusString = _getStatusString(parcel.status);

      final matchSearch = parcel.recipientName
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          parcel.barcode.contains(searchQuery);

      final matchRegion =
          selectedRegion == null || parcel.deliveryRegion == selectedRegion;

      final matchStatus =
          selectedStatus == null || statusString == selectedStatus;

      return matchSearch && matchRegion && matchStatus;
    }).toList();
  }

  List<String> preparingStatuses = [
    'بانتظار الملصق',
    'جاهز للارسال',
  ];

  List<String> deliveryStatuses = [
    'في الطريق للموزع',
    'مخزن الموزع',
    'في الطريق للزبون',
    'تم التوصيل',
    'طرد راجع',
    'ملغي',
  ];

  List<ParcelModel> _getPreparingParcels(List<ParcelModel> parcels) {
    return parcels
        .where((p) => preparingStatuses.contains(_getStatusString(p.status)))
        .toList();
  }

  List<ParcelModel> _getDeliveryParcels(List<ParcelModel> parcels) {
    return parcels
        .where((p) => deliveryStatuses.contains(_getStatusString(p.status)))
        .toList();
  }

  Widget buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'بحث (اسم المستلم أو الباركود)',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() => searchQuery = val),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedRegion,
                  decoration: const InputDecoration(labelText: 'المنطقة'),
                  items: regions
                      .map((region) =>
                          DropdownMenuItem(value: region, child: Text(region)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedRegion = val),
                  isExpanded: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'الحالة'),
                  items: statuses
                      .map((status) =>
                          DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedStatus = val),
                  isExpanded: true,
                ),
              ),
              if (selectedRegion != null || selectedStatus != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    selectedRegion = null;
                    selectedStatus = null;
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildParcelList(List<ParcelModel> parcels) {
    if (parcels.isEmpty) {
      return const Center(child: Text('لا يوجد طرود حالياً'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: parcels.length,
      itemBuilder: (context, index) => ParcelDetailCard(
        parcel: parcels[index],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddParcelPage(parcel: parcels[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in to view parcels'));
    }

    return StreamBuilder<List<ParcelModel>>(
      stream: _firestoreService.streamParcelsByMerchant(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allParcels = snapshot.data ?? [];
        final filteredParcels = _filterParcels(allParcels);
        final preparingParcels = _getPreparingParcels(filteredParcels);
        final deliveryParcels = _getDeliveryParcels(filteredParcels);

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Colors.black,
                tabs: const [
                  Tab(text: '📦 التغليف والتجهيز'),
                  Tab(text: '🚚 التوصيل للزبون'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        buildFilterHeader(),
                        Expanded(child: buildParcelList(preparingParcels)),
                      ],
                    ),
                    Column(
                      children: [
                        buildFilterHeader(),
                        Expanded(child: buildParcelList(deliveryParcels)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
