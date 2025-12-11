import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/models/privacy_policy_model.dart';
import 'package:wasslni_plus/services/privacy_policy_service.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:intl/intl.dart';

class EnhancedPrivacyPolicyPage extends StatefulWidget {
  final bool requireAcceptance;
  final VoidCallback? onAccepted;
  final VoidCallback? onDeclined;

  const EnhancedPrivacyPolicyPage({
    super.key,
    this.requireAcceptance = false,
    this.onAccepted,
    this.onDeclined,
  });

  @override
  State<EnhancedPrivacyPolicyPage> createState() =>
      _EnhancedPrivacyPolicyPageState();
}

class _EnhancedPrivacyPolicyPageState extends State<EnhancedPrivacyPolicyPage> {
  final _privacyPolicyService = PrivacyPolicyService();
  final _authService = AuthService();
  PrivacyPolicyModel? _policy;
  bool _isLoading = true;
  bool _hasScrolledToBottom = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasScrolledToBottom) {
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    }
  }

  Future<void> _loadPrivacyPolicy() async {
    try {
      final policy = await _privacyPolicyService.getActivePrivacyPolicy();
      if (mounted) {
        setState(() {
          _policy = policy;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading privacy policy: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAccept() async {
    if (_policy == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    try {
      await _privacyPolicyService.recordUserAcceptance(
        userId: user.uid,
        policyVersion: _policy!.version,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).privacy_policy_accepted),
            backgroundColor: Colors.green,
          ),
        );

        widget.onAccepted?.call();

        if (widget.requireAcceptance) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDecline() async {
    if (_policy == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).decline_privacy_policy),
        content: Text(S.of(context).decline_privacy_policy_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.of(context).decline),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _privacyPolicyService.recordUserDecline(
        userId: user.uid,
        policyVersion: _policy!.version,
      );

      widget.onDeclined?.call();

      if (mounted && widget.requireAcceptance) {
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportToPdf() async {
    if (_policy == null) return;

    try {
      final pdf = pw.Document();
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      final content = isArabic ? _policy!.contentAr : _policy!.contentEn;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Privacy Policy - Wasslni Plus',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text('Version: ${_policy!.version}'),
                pw.Text(
                  'Effective Date: ${DateFormat.yMMMd().format(_policy!.effectiveDate)}',
                ),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Text(content),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      debugPrint('Error exporting to PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.privacy_policy),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_policy != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _exportToPdf,
              tooltip: tr.export_to_pdf,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _policy == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        tr.error_loading_privacy_policy,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadPrivacyPolicy,
                        icon: const Icon(Icons.refresh),
                        label: Text(tr.retry),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Version info banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: AppStyles.primaryColor.withValues(alpha: 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppStyles.primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                '${tr.version}: ${_policy!.version}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tr.effective_date}: ${DateFormat.yMMMd().format(_policy!.effectiveDate)}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Policy content
                    Expanded(
                      child: Markdown(
                        controller: _scrollController,
                        data:
                            isArabic ? _policy!.contentAr : _policy!.contentEn,
                        styleSheet: MarkdownStyleSheet(
                          h1: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          h2: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          p: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ),

                    // Accept/Decline buttons (if required)
                    if (widget.requireAcceptance)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (!_hasScrolledToBottom)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_downward,
                                        size: 16, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        tr.scroll_to_read_all,
                                        style: const TextStyle(
                                          color: Colors.orange,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _handleDecline,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    child: Text(tr.decline),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: FilledButton(
                                    onPressed: _hasScrolledToBottom
                                        ? _handleAccept
                                        : null,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppStyles.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    child: Text(tr.accept),
                                  ),
                                ),
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
