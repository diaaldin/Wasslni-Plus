import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

import 'package:barcode/barcode.dart';

class PrintLabelService {
  /// Generates and prints a shipping label for a parcel
  static Future<void> printShippingLabel(ParcelModel parcel,
      {String? merchantName}) async {
    final pdf = pw.Document();

    // Try to load font that supports Arabic (if available)
    pw.Font? arabicFont;
    try {
      final fontData =
          await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
      arabicFont = pw.Font.ttf(fontData);
    } catch (e) {
      debugPrint('Error loading Arabic font: $e');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        margin: const pw.EdgeInsets.all(16),
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFont,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Logo/Company Name
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 2),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Wasslni Plus',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'وصلني بلس',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        fontFallback: [if (arabicFont != null) arabicFont],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // Barcode
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: parcel.barcode,
                  width: 150,
                  height: 50,
                  drawText: true,
                ),
              ),
              pw.SizedBox(height: 12),

              // Recipient Information
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'TO / إلى',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      parcel.recipientName,
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      parcel.recipientPhone,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      parcel.deliveryAddress,
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(
                      parcel.deliveryRegion,
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // Merchant Info
              if (merchantName != null)
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(4),
                    color: PdfColors.grey100,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'FROM / من',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.Text(
                        merchantName,
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              pw.Spacer(),

              // Footer with parcel details
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'COD: ₪${parcel.totalPrice.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          fontFallback: [if (arabicFont != null) arabicFont],
                        ),
                      ),
                      if (parcel.requiresSignature)
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                            borderRadius: pw.BorderRadius.circular(2),
                          ),
                          child: pw.Text(
                            'Signature Required',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ),
                    ],
                  ),
                  pw.Text(
                    _formatDate(parcel.createdAt),
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Shipping_Label_${parcel.barcode}',
    );
  }

  /// Generates and prints a receipt for a parcel
  static Future<void> printReceipt(ParcelModel parcel,
      {String? merchantName}) async {
    final pdf = pw.Document();

    // Try to load Arabic font
    pw.Font? arabicFont;
    try {
      final fontData =
          await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
      arabicFont = pw.Font.ttf(fontData);
    } catch (e) {
      debugPrint('Error loading Arabic font: $e');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(8),
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFont,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'Wasslni Plus',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Receipt / إيصال',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 8),

              // Barcode
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: parcel.barcode,
                  width: 120,
                  height: 40,
                  drawText: true,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),

              // Parcel Details
              _buildReceiptRow('Recipient', parcel.recipientName, arabicFont),
              _buildReceiptRow('Phone', parcel.recipientPhone, arabicFont),
              _buildReceiptRow('Region', parcel.deliveryRegion, arabicFont),
              _buildReceiptRow('Address', parcel.deliveryAddress, arabicFont),
              pw.Divider(),

              // Pricing
              _buildReceiptRow('Parcel Price',
                  '₪${parcel.parcelPrice.toStringAsFixed(2)}', arabicFont),
              _buildReceiptRow('Delivery Fee',
                  '₪${parcel.deliveryFee.toStringAsFixed(2)}', arabicFont),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '₪${parcel.totalPrice.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      fontFallback: [if (arabicFont != null) arabicFont],
                    ),
                  ),
                ],
              ),
              pw.Divider(),

              // Footer
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'Date: ${_formatDate(parcel.createdAt)}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Thank you! شكراً',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Receipt_${parcel.barcode}',
    );
  }

  static pw.Widget _buildReceiptRow(
      String label, String value, pw.Font? arabicFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Preview the shipping label PDF
  static Future<Uint8List> generateLabelPreview(ParcelModel parcel,
      {String? merchantName}) async {
    final pdf = pw.Document();

    pw.Font? arabicFont;
    try {
      final fontData =
          await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
      arabicFont = pw.Font.ttf(fontData);
    } catch (e) {
      debugPrint('Error loading Arabic font: $e');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        margin: const pw.EdgeInsets.all(16),
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFont,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 2),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Wasslni Plus',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        fontFallback: [if (arabicFont != null) arabicFont],
                      ),
                    ),
                    pw.Text(
                      'وصلني بلس',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: parcel.barcode,
                  width: 150,
                  height: 50,
                  drawText: true,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TO:',
                        style: const pw.TextStyle(
                            fontSize: 10, color: PdfColors.grey700)),
                    pw.Text(parcel.recipientName,
                        style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(parcel.recipientPhone,
                        style: const pw.TextStyle(fontSize: 12)),
                    pw.Text(parcel.deliveryAddress,
                        style: pw.TextStyle(fontSize: 11, font: arabicFont)),
                    pw.Text(parcel.deliveryRegion,
                        style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('COD: ₪${parcel.totalPrice.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        fontFallback: [if (arabicFont != null) arabicFont],
                      )),
                  pw.Text(_formatDate(parcel.createdAt),
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
