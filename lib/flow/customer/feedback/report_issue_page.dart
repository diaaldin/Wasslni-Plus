import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/models/notification_model.dart';

class ReportIssuePage extends StatefulWidget {
  final ParcelModel parcel;

  const ReportIssuePage({
    super.key,
    required this.parcel,
  });

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedIssueType;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _issueTypes = [
    {'key': 'damaged_package', 'icon': Icons.broken_image},
    {'key': 'wrong_item', 'icon': Icons.error_outline},
    {'key': 'missing_items', 'icon': Icons.remove_shopping_cart},
    {'key': 'late_delivery', 'icon': Icons.access_time},
    {'key': 'poor_service', 'icon': Icons.sentiment_dissatisfied},
    {'key': 'other', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      _showError(tr.login_failed);
      return;
    }

    if (_selectedIssueType == null) {
      _showError(tr.please_select_issue_type);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showError(tr.please_describe_issue);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create a notification for the merchant and admin
      final issueDescription = _descriptionController.text.trim();
      final issueTypeKey = _selectedIssueType!;

      // Notify merchant
      if (widget.parcel.merchantId.isNotEmpty) {
        await _firestoreService.createNotification(
          NotificationModel(
            id: '',
            userId: widget.parcel.merchantId,
            title: tr.issue_reported,
            body:
                '${tr.parcel_details} #${widget.parcel.barcode}: ${_getIssueTypeText(issueTypeKey, tr)}',
            type: NotificationType.warning,
            isRead: false,
            relatedParcelId: widget.parcel.id,
            createdAt: DateTime.now(),
          ),
        );
      }

      // Add a note to the parcel
      await _firestoreService.updateParcel(
        widget.parcel.id!,
        {
          'deliveryNotes':
              '${widget.parcel.deliveryNotes ?? ''}\n[ISSUE REPORTED] ${_getIssueTypeText(issueTypeKey, tr)}: $issueDescription',
          'updatedAt': DateTime.now(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr.issue_reported_successfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showError('${tr.error_occurred}: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getIssueTypeText(String key, S tr) {
    switch (key) {
      case 'damaged_package':
        return tr.issue_damaged_package;
      case 'wrong_item':
        return tr.issue_wrong_item;
      case 'missing_items':
        return tr.issue_missing_items;
      case 'late_delivery':
        return tr.issue_late_delivery;
      case 'poor_service':
        return tr.issue_poor_service;
      case 'other':
        return tr.issue_other;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.report_issue),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parcel Info Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          '${tr.parcel_details} #${widget.parcel.barcode}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('${tr.status_label}: ${widget.parcel.status.name}'),
                    Text(
                        '${tr.recipient_name}: ${widget.parcel.recipientName}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Issue Type Selection
            Text(
              tr.select_issue_type,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr.what_went_wrong,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Issue Type Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _issueTypes.length,
              itemBuilder: (context, index) {
                final issue = _issueTypes[index];
                final isSelected = _selectedIssueType == issue['key'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIssueType = issue['key'] as String;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppStyles.primaryColor
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? AppStyles.primaryColor.withValues(alpha: 0.1)
                          : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          issue['icon'] as IconData,
                          size: 32,
                          color: isSelected
                              ? AppStyles.primaryColor
                              : Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getIssueTypeText(issue['key'] as String, tr),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppStyles.primaryColor
                                : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Description Section
            Text(
              tr.describe_issue,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: tr.provide_details,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tr.issue_report_info,
                      style: TextStyle(color: Colors.blue[700], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitReport,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.report_problem),
                label: Text(
                  _isSubmitting ? tr.submitting : tr.submit_report,
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
