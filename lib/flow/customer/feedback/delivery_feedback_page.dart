import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/models/review_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class DeliveryFeedbackPage extends StatefulWidget {
  final ParcelModel parcel;

  const DeliveryFeedbackPage({
    super.key,
    required this.parcel,
  });

  @override
  State<DeliveryFeedbackPage> createState() => _DeliveryFeedbackPageState();
}

class _DeliveryFeedbackPageState extends State<DeliveryFeedbackPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _commentController = TextEditingController();

  int _rating = 0;
  double _tip = 0.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    final tr = S.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      _showError(tr.login_failed);
      return;
    }

    if (_rating == 0) {
      _showError(tr.please_select_rating);
      return;
    }

    if (widget.parcel.courierId == null) {
      _showError(tr.courier_not_assigned);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final review = ReviewModel(
        id: '',
        parcelId: widget.parcel.id!,
        customerId: user.uid,
        courierId: widget.parcel.courierId!,
        rating: _rating.toDouble(),
        comment: _commentController.text.trim(),
        tip: _tip,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createReview(review);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr.feedback_submitted_successfully),
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

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.delivery_feedback),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Info Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping,
                            color: AppStyles.primaryColor),
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
                    _buildInfoRow(Icons.person, tr.recipient_name,
                        widget.parcel.recipientName),
                    _buildInfoRow(Icons.location_on, tr.delivery_region,
                        widget.parcel.deliveryRegion),
                    if (widget.parcel.actualDeliveryTime != null)
                      _buildInfoRow(
                        Icons.access_time,
                        tr.delivered_at,
                        '${widget.parcel.actualDeliveryTime!.day}/${widget.parcel.actualDeliveryTime!.month}/${widget.parcel.actualDeliveryTime!.year}',
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Rating Section
            Text(
              tr.rate_delivery_experience,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr.how_was_your_delivery,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Star Rating
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: 48,
                      color: index < _rating ? Colors.amber : Colors.grey,
                    ),
                  );
                }),
              ),
            ),

            if (_rating > 0)
              Center(
                child: Text(
                  _getRatingText(_rating, tr),
                  style: const TextStyle(
                    color: AppStyles.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Comment Section
            Text(
              tr.add_comment,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: tr.share_your_experience,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 24),

            // Tip Section
            Text(
              tr.tip_courier,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr.tip_courier_description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),

            // Tip Amount Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [0, 5, 10, 20, 50].map((amount) {
                return ChoiceChip(
                  label: Text(amount == 0 ? tr.no_tip : '₪$amount'),
                  selected: _tip == amount.toDouble(),
                  onSelected: (selected) {
                    setState(() {
                      _tip = selected ? amount.toDouble() : 0.0;
                    });
                  },
                  selectedColor: AppStyles.primaryColor.withValues(alpha: 0.3),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitFeedback,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? tr.submitting : tr.submit_feedback,
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating, S tr) {
    switch (rating) {
      case 1:
        return tr.rating_poor;
      case 2:
        return tr.rating_fair;
      case 3:
        return tr.rating_good;
      case 4:
        return tr.rating_very_good;
      case 5:
        return tr.rating_excellent;
      default:
        return '';
    }
  }
}
