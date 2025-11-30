import 'package:flutter/material.dart';
import 'package:wasslni_plus/flow/common/settings/parcel/parcel_details_card.dart';

class MerchantParcelsPage extends StatefulWidget {
  const MerchantParcelsPage({super.key});

  @override
  State<MerchantParcelsPage> createState() => _MerchantParcelsPageState();
}

class _MerchantParcelsPageState extends State<MerchantParcelsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
  ];

  final List<Map<String, dynamic>> allParcels = [
    {
      'recipient': 'أحمد محمد',
      'region': 'القدس',
      'status': 'في الطريق للزبون',
      'cost': 100,
      'location': 'شارع الزهراء',
      'courier': 'خالد',
      'assigned': true,
      'barcode': '1234567890',
    },
    {
      'recipient': 'ليلى عمر',
      'region': 'الضفة',
      'status': 'جاهز للارسال',
      'cost': 85,
      'location': 'دوار الساعة',
      'courier': 'سليم',
      'assigned': true,
      'barcode': '0987654321',
    },
    {
      'recipient': 'نور حمد',
      'region': 'القدس',
      'status': 'بانتظار الملصق',
      'cost': 75,
      'location': 'حي الصوانة',
      'courier': 'فادي',
      'assigned': false,
      'barcode': '9876543210',
    },
    {
      'recipient': 'علا يوسف',
      'region': 'الداخل',
      'status': 'مخزن الموزع',
      'cost': 120,
      'location': 'يافا',
      'courier': 'رامي',
      'assigned': true,
      'barcode': '1122334455',
    },
    {
      'recipient': 'أمينة حسن',
      'region': 'الضفة',
      'status': 'تم التوصيل',
      'cost': 90,
      'location': 'رام الله',
      'courier': 'سعيد',
      'assigned': true,
      'barcode': '5566778899',
    },
    {
      'recipient': 'محمد نادر',
      'region': 'القدس',
      'status': 'طرد راجع',
      'cost': 60,
      'location': 'سلوان',
      'courier': 'وسيم',
      'assigned': true,
      'barcode': '6677889900',
      'returnReason': 'العميل لم يرد على الاتصال',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  List<Map<String, dynamic>> get filteredParcels {
    return allParcels.where((parcel) {
      final matchSearch = parcel['recipient']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          parcel['barcode'] == searchQuery;
      final matchRegion =
          selectedRegion == null || parcel['region'] == selectedRegion;
      final matchStatus =
          selectedStatus == null || parcel['status'] == selectedStatus;
      return matchSearch && matchRegion && matchStatus;
    }).toList();
  }

  List<String> preparingStatuses = [
    'بانتظار الملصق',
    'جاهز للارسال',
  ];
  List<String> deliveryStatuses = [
    'في الطريق للزبون',
    'مخزن الموزع',
    'تم التوصيل',
    'طرد راجع',
  ];

  List<Map<String, dynamic>> get preparingParcels => filteredParcels
      .where((p) => preparingStatuses.contains(p['status']))
      .toList();

  List<Map<String, dynamic>> get deliveryParcels => filteredParcels
      .where((p) => deliveryStatuses.contains(p['status']))
      .toList();

  Widget buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
            ],
          ),
        ],
      ),
    );
  }

  Widget buildParcelList(List<Map<String, dynamic>> parcels) {
    if (parcels.isEmpty) {
      return const Center(child: Text('لا يوجد طرود حالياً'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: parcels.length,
      itemBuilder: (context, index) => ParcelDetailCard(parcel: parcels[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
