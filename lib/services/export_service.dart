import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  /// Export parcels to PDF and share/print
  static Future<void> exportToPdf(
    List<ParcelModel> parcels, {
    String? title,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pdf = pw.Document();

    // Calculate summary stats
    final totalParcels = parcels.length;
    final deliveredCount =
        parcels.where((p) => p.status == ParcelStatus.delivered).length;
    final pendingCount = parcels
        .where((p) =>
            p.status == ParcelStatus.awaitingLabel ||
            p.status == ParcelStatus.readyToShip)
        .length;
    final inTransitCount = parcels
        .where((p) =>
            p.status == ParcelStatus.outForDelivery ||
            p.status == ParcelStatus.enRouteDistributor)
        .length;
    final cancelledCount =
        parcels.where((p) => p.status == ParcelStatus.cancelled).length;
    final totalRevenue = parcels
        .where((p) => p.status == ParcelStatus.delivered)
        .fold(0.0, (sum, p) => sum + p.totalPrice);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Wasslni Plus',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.Text(
                  title ?? 'Parcels Report',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Generated: ${_formatDateTime(DateTime.now())}',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              ),
            ),
            if (startDate != null && endDate != null)
              pw.Text(
                'Date Range: ${_formatDate(startDate)} - ${_formatDate(endDate)}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            pw.Divider(),
          ],
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 16),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ),
        build: (context) => [
          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildStatBox('Total', totalParcels.toString(), PdfColors.blue),
                _buildStatBox(
                    'Delivered', deliveredCount.toString(), PdfColors.green),
                _buildStatBox(
                    'Pending', pendingCount.toString(), PdfColors.orange),
                _buildStatBox(
                    'In Transit', inTransitCount.toString(), PdfColors.purple),
                _buildStatBox(
                    'Cancelled', cancelledCount.toString(), PdfColors.red),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Revenue
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Total Revenue (Delivered): ',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '₪${totalRevenue.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green800,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Table Header
          pw.Text(
            'Parcel Details',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),

          // Table
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(1.2),
              5: const pw.FlexColumnWidth(1.3),
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableHeader('Barcode'),
                  _buildTableHeader('Recipient'),
                  _buildTableHeader('Region'),
                  _buildTableHeader('Address'),
                  _buildTableHeader('Status'),
                  _buildTableHeader('Total'),
                ],
              ),
              // Data Rows
              ...parcels.map((parcel) => pw.TableRow(
                    children: [
                      _buildTableCell(parcel.barcode),
                      _buildTableCell(parcel.recipientName),
                      _buildTableCell(parcel.deliveryRegion),
                      _buildTableCell(parcel.deliveryAddress, maxLines: 2),
                      _buildTableCell(_getStatusText(parcel.status)),
                      _buildTableCell(
                          '₪${parcel.totalPrice.toStringAsFixed(0)}'),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Parcels_Report_${_formatDateForFilename(DateTime.now())}',
    );
  }

  /// Export parcels to CSV (Excel compatible)
  static Future<String> exportToCsv(
    List<ParcelModel> parcels, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln(
        'Barcode,Recipient Name,Recipient Phone,Alternate Phone,Region,Address,Description,Parcel Price,Delivery Fee,Total Price,Status,Created Date,Weight,Signature Required');

    // Data Rows
    for (final parcel in parcels) {
      buffer.writeln([
        _escapeCsv(parcel.barcode),
        _escapeCsv(parcel.recipientName),
        _escapeCsv(parcel.recipientPhone),
        _escapeCsv(parcel.recipientAltPhone ?? ''),
        _escapeCsv(parcel.deliveryRegion),
        _escapeCsv(parcel.deliveryAddress),
        _escapeCsv(parcel.description ?? ''),
        parcel.parcelPrice.toStringAsFixed(2),
        parcel.deliveryFee.toStringAsFixed(2),
        parcel.totalPrice.toStringAsFixed(2),
        _getStatusText(parcel.status),
        _formatDate(parcel.createdAt),
        parcel.weight?.toString() ?? '',
        parcel.requiresSignature ? 'Yes' : 'No',
      ].join(','));
    }

    return buffer.toString();
  }

  /// Export to CSV and share the file
  static Future<void> exportAndShareCsv(
    List<ParcelModel> parcels, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final csvContent =
        await exportToCsv(parcels, startDate: startDate, endDate: endDate);

    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final fileName =
        'Parcels_Export_${_formatDateForFilename(DateTime.now())}.csv';
    final file = File('${directory.path}/$fileName');

    // Write CSV content
    await file.writeAsString(csvContent);

    // Share the file
    await Share.shareXFiles([XFile(file.path)], text: 'Parcels Export');
  }

  // Helper methods
  static pw.Widget _buildStatBox(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {int maxLines = 1}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8),
        maxLines: maxLines,
      ),
    );
  }

  static String _getStatusText(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return 'Pending';
      case ParcelStatus.readyToShip:
        return 'Ready';
      case ParcelStatus.enRouteDistributor:
        return 'En Route';
      case ParcelStatus.atWarehouse:
        return 'Warehouse';
      case ParcelStatus.outForDelivery:
        return 'Out';
      case ParcelStatus.delivered:
        return 'Delivered';
      case ParcelStatus.returned:
        return 'Returned';
      case ParcelStatus.cancelled:
        return 'Cancelled';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDateForFilename(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
