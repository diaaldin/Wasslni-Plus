import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class BulkUploadService {
  final FirestoreService _firestoreService = FirestoreService();

  /// Generate CSV template for bulk upload
  static String generateTemplate() {
    final headers = [
      'Recipient Name*',
      'Recipient Phone*',
      'Alternate Phone',
      'Delivery Address*',
      'Delivery Region*',
      'Description',
      'Parcel Price*',
      'Weight (kg)',
      'Length (cm)',
      'Width (cm)',
      'Height (cm)',
      'Delivery Instructions',
      'Requires Signature (Yes/No)',
    ];

    final sampleRow = [
      'John Doe',
      '+972501234567',
      '+972501234568',
      '123 Main St, Apt 4',
      'الداخل',
      'Fragile items',
      '150.00',
      '2.5',
      '30',
      '20',
      '15',
      'Call before delivery',
      'Yes',
    ];

    return const ListToCsvConverter().convert([headers, sampleRow]);
  }

  /// Pick a CSV file from the file system
  static Future<File?> pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  /// Parse CSV file and create parcels
  Future<BulkUploadResult> uploadParcelsFromCsv(
    File csvFile,
    String merchantId,
  ) async {
    final results = BulkUploadResult();

    try {
      // Read CSV file
      final input = await csvFile.readAsString();
      final csvData = const CsvToListConverter().convert(input);

      if (csvData.isEmpty) {
        results.errors.add('CSV file is empty');
        return results;
      }

      // Skip header row
      final dataRows = csvData.skip(1);

      for (var i = 0; i < dataRows.length; i++) {
        final row = dataRows.elementAt(i);
        final rowNumber =
            i + 2; // +2 because we skipped header and rows are 1-indexed

        try {
          final parcel = await _parseRowToParcel(row, merchantId, rowNumber);

          // Create parcel in Firestore
          await _firestoreService.createParcel(parcel);
          results.successCount++;
        } catch (e) {
          results.errors.add('Row $rowNumber: $e');
          results.failureCount++;
        }
      }
    } catch (e) {
      results.errors.add('Failed to parse CSV file: $e');
    }

    return results;
  }

  /// Parse a CSV row into a ParcelModel
  Future<ParcelModel> _parseRowToParcel(
    List<dynamic> row,
    String merchantId,
    int rowNumber,
  ) async {
    // Validate required fields
    if (row.length < 7) {
      throw Exception('Insufficient columns (minimum 7 required)');
    }

    final recipientName = _getStringValue(row, 0);
    final recipientPhone = _getStringValue(row, 1);
    final altPhone = _getStringValue(row, 2);
    final deliveryAddress = _getStringValue(row, 3);
    final deliveryRegion = _getStringValue(row, 4);
    final description = _getStringValue(row, 5);
    final parcelPriceStr = _getStringValue(row, 6);

    // Validate required fields
    if (recipientName.isEmpty) {
      throw Exception('Recipient Name is required');
    }
    if (recipientPhone.isEmpty) {
      throw Exception('Recipient Phone is required');
    }
    if (deliveryAddress.isEmpty) {
      throw Exception('Delivery Address is required');
    }
    if (deliveryRegion.isEmpty) {
      throw Exception('Delivery Region is required');
    }
    if (parcelPriceStr.isEmpty) {
      throw Exception('Parcel Price is required');
    }

    // Validate region
    const validRegions = ['الداخل', 'القدس', 'الضفة'];
    if (!validRegions.contains(deliveryRegion)) {
      throw Exception(
          'Invalid region. Must be one of: ${validRegions.join(", ")}');
    }

    // Parse numeric values
    final parcelPrice = double.tryParse(parcelPriceStr);
    if (parcelPrice == null) {
      throw Exception('Invalid Parcel Price');
    }

    // Optional fields
    final weight = row.length > 7 ? _parseDouble(row[7]) : null;
    final length = row.length > 8 ? _parseDouble(row[8]) : null;
    final width = row.length > 9 ? _parseDouble(row[9]) : null;
    final height = row.length > 10 ? _parseDouble(row[10]) : null;
    final deliveryInstructions =
        row.length > 11 ? _getStringValue(row, 11) : null;
    final requiresSignature = row.length > 12
        ? _getStringValue(row, 12).toLowerCase() == 'yes'
        : false;

    // Build dimensions map if all values are present
    Map<String, double>? dimensions;
    if (length != null && width != null && height != null) {
      dimensions = {
        'length': length,
        'width': width,
        'height': height,
      };
    }

    // Calculate delivery fee based on region
    const regionPrices = {
      'الداخل': 20.0,
      'القدس': 25.0,
      'الضفة': 30.0,
    };
    final deliveryFee = regionPrices[deliveryRegion] ?? 20.0;

    // Generate unique barcode
    final barcode = await _firestoreService.generateUniqueBarcode();

    return ParcelModel(
      barcode: barcode,
      merchantId: merchantId,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      recipientAltPhone: altPhone.isNotEmpty ? altPhone : null,
      deliveryAddress: deliveryAddress,
      deliveryRegion: deliveryRegion,
      description: description.isNotEmpty ? description : null,
      weight: weight,
      dimensions: dimensions,
      imageUrls: const [],
      deliveryInstructions: deliveryInstructions?.isNotEmpty == true
          ? deliveryInstructions
          : null,
      requiresSignature: requiresSignature,
      parcelPrice: parcelPrice,
      deliveryFee: deliveryFee,
      totalPrice: parcelPrice + deliveryFee,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: ParcelStatus.awaitingLabel,
    );
  }

  String _getStringValue(List<dynamic> row, int index) {
    if (index >= row.length) return '';
    final value = row[index];
    return value?.toString().trim() ?? '';
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    final str = value.toString().trim();
    if (str.isEmpty) return null;
    return double.tryParse(str);
  }
}

class BulkUploadResult {
  int successCount = 0;
  int failureCount = 0;
  List<String> errors = [];

  bool get hasErrors => errors.isNotEmpty;
  int get totalProcessed => successCount + failureCount;
}
