import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wasslni_plus/flow/common/settings/parcel/parcel_details_card.dart';
import 'package:wasslni_plus/flow/merchant/parcel/add_paracel_page.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/flow/merchant/parcel/parcel_details_page.dart';
import 'package:wasslni_plus/services/export_service.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/services/bulk_upload_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  /// Download CSV template
  Future<void> _downloadTemplate() async {
    final tr = S.of(context);
    try {
      final csvContent = BulkUploadService.generateTemplate();

      // Get downloads directory
      final directory = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/parcels_template.csv');

      await file.writeAsString(csvContent);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${tr.download_template}: ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// Upload bulk parcels from CSV
  Future<void> _uploadBulkParcels() async {
    final tr = S.of(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in')),
      );
      return;
    }

    try {
      // Pick CSV file
      final file = await BulkUploadService.pickCsvFile();
      if (file == null) return;

      // Show processing dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(tr.processing_file),
              ],
            ),
          ),
        );
      }

      // Process file
      final uploadService = BulkUploadService();
      final result = await uploadService.uploadParcelsFromCsv(file, user.uid);

      // Close processing dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show result dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(tr.bulk_upload),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${tr.parcels_imported}: ${result.successCount}'),
                if (result.failureCount > 0)
                  Text('Failed: ${result.failureCount}',
                      style: const TextStyle(color: Colors.red)),
                if (result.hasErrors) ...[
                  const SizedBox(height: 16),
                  const Text('Errors:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: result.errors
                            .map((e) => Text('• $e',
                                style: const TextStyle(fontSize: 12)))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close processing dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${tr.upload_error}: $e')),
        );
      }
    }
  }

  Widget buildFilterHeader(List<ParcelModel> parcelsToExport) {
    final tr = S.of(context);
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${tr.total_parcels}: ${parcelsToExport.length}'),
              const Spacer(),
              // Bulk Upload Button
              PopupMenuButton<String>(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.upload_file),
                    const SizedBox(width: 4),
                    Text(tr.bulk_upload),
                  ],
                ),
                onSelected: (value) async {
                  if (value == 'template') {
                    await _downloadTemplate();
                  } else if (value == 'upload') {
                    await _uploadBulkParcels();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'template',
                    child: Row(
                      children: [
                        const Icon(Icons.download, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(tr.download_template),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'upload',
                    child: Row(
                      children: [
                        const Icon(Icons.upload, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(tr.upload_csv),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.download),
                    const SizedBox(width: 4),
                    Text(tr.export),
                  ],
                ),
                onSelected: (value) async {
                  if (parcelsToExport.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No parcels to export')),
                    );
                    return;
                  }

                  try {
                    if (value == 'pdf') {
                      await ExportService.exportToPdf(
                        parcelsToExport,
                        title: tr.parcels_report,
                      );
                    } else if (value == 'excel') {
                      await ExportService.exportAndShareCsv(parcelsToExport);
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr.export_success)),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${tr.export_error}: $e')),
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pdf',
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(tr.export_pdf),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'excel',
                    child: Row(
                      children: [
                        const Icon(Icons.table_chart, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(tr.export_excel),
                      ],
                    ),
                  ),
                ],
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
              builder: (_) => ParcelDetailsPage(parcel: parcels[index]),
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
                        buildFilterHeader(preparingParcels),
                        Expanded(child: buildParcelList(preparingParcels)),
                      ],
                    ),
                    Column(
                      children: [
                        buildFilterHeader(deliveryParcels),
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
