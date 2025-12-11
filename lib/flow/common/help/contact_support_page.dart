import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  File? _selectedImage;
  bool _isSubmitting = false;

  String _selectedCategory = 'general';

  final List<String> _categories = [
    'general',
    'technical',
    'delivery',
    'payment',
    'account',
    'other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _getCategoryName(String category, String languageCode) {
    final categories = {
      'general': languageCode == 'ar' ? 'عام' : 'General',
      'technical': languageCode == 'ar' ? 'مشاكل تقنية' : 'Technical Issue',
      'delivery': languageCode == 'ar' ? 'مشكلة توصيل' : 'Delivery Issue',
      'payment': languageCode == 'ar' ? 'الدفع' : 'Payment',
      'account': languageCode == 'ar' ? 'الحساب' : 'Account',
      'other': languageCode == 'ar' ? 'أخرى' : 'Other',
    };
    return categories[category] ?? category;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to select image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to submit a support request'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create support request in Firestore
      final requestData = {
        'userId': user.uid,
        'userEmail': user.email,
        'userPhone': user.phoneNumber,
        'category': _selectedCategory,
        'subject': _subjectController.text.trim(),
        'message': _messageController.text.trim(),
        'status': 'open', // open, in_progress, resolved
        'priority': 'normal', // low, normal, high, urgent
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'hasScreenshot': _selectedImage != null,
      };

      final docRef = await FirebaseFirestore.instance
          .collection('support_requests')
          .add(requestData);

      debugPrint('Support request created with ID: ${docRef.id}');

      // TODO: Upload screenshot if selected
      // This would require Firebase Storage integration
      if (_selectedImage != null) {
        debugPrint('Screenshot selected but upload not yet implemented');
        // Future enhancement: Upload to Firebase Storage
      }

      if (mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            title: Text(S.of(context).request_submitted),
            content: Text(S.of(context).support_request_success),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous page
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Clear form
        _subjectController.clear();
        _messageController.clear();
        setState(() {
          _selectedImage = null;
          _selectedCategory = 'general';
        });
      }
    } catch (e) {
      debugPrint('Error submitting support request: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.contact_support),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                color: AppStyles.primaryColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.support_agent,
                        size: 48,
                        color: AppStyles.primaryColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr.contact_support_team,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        languageCode == 'ar'
                            ? 'سنرد عليك خلال 24-48 ساعة'
                            : 'We\'ll respond within 24-48 hours',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category Selection
              Text(
                languageCode == 'ar' ? 'الفئة' : 'Category',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_getCategoryName(category, languageCode)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Subject
              Text(
                tr.subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: tr.enter_subject,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return tr.please_enter_subject;
                  }
                  if (value.trim().length < 5) {
                    return languageCode == 'ar'
                        ? 'الموضوع يجب أن يكون 5 أحرف على الأقل'
                        : 'Subject must be at least 5 characters';
                  }
                  return null;
                },
                maxLength: 100,
              ),

              const SizedBox(height: 20),

              // Message
              Text(
                languageCode == 'ar' ? 'الرسالة' : 'Message',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: tr.describe_issue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return tr.please_describe_issue;
                  }
                  if (value.trim().length < 20) {
                    return languageCode == 'ar'
                        ? 'الرسالة يجب أن تكون 20 حرف على الأقل'
                        : 'Message must be at least 20 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Screenshot Section
              Text(
                tr.attach_screenshot,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_selectedImage == null)
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(
                    languageCode == 'ar' ? 'اختر صورة' : 'Choose Image',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                )
              else
                Card(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.refresh),
                              label: Text(
                                languageCode == 'ar' ? 'تغيير' : 'Change',
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: Text(
                                languageCode == 'ar' ? 'حذف' : 'Remove',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          tr.submit_request,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Alternative Contact Methods
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageCode == 'ar'
                            ? 'طرق الاتصال الأخرى'
                            : 'Other Contact Methods',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ContactMethod(
                        icon: Icons.email,
                        label: languageCode == 'ar'
                            ? 'البريد الإلكتروني'
                            : 'Email',
                        value: 'support@wasslniplus.com',
                      ),
                      const SizedBox(height: 8),
                      _ContactMethod(
                        icon: Icons.phone,
                        label: languageCode == 'ar' ? 'الهاتف' : 'Phone',
                        value: '00972-0526041850',
                      ),
                      const SizedBox(height: 8),
                      _ContactMethod(
                        icon: Icons.access_time,
                        label: languageCode == 'ar' ? 'ساعات العمل' : 'Hours',
                        value: languageCode == 'ar'
                            ? 'الأحد-الخميس، 9 ص - 5 م'
                            : 'Sun-Thu, 9 AM - 5 PM',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactMethod extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactMethod({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppStyles.primaryColor),
        const SizedBox(width: 12),
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
    );
  }
}
