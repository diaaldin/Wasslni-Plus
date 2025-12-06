import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

class DeliveryChecklistSheet extends StatefulWidget {
  final ParcelModel parcel;
  final VoidCallback onCompleted;

  const DeliveryChecklistSheet({
    super.key,
    required this.parcel,
    required this.onCompleted,
  });

  @override
  State<DeliveryChecklistSheet> createState() => _DeliveryChecklistSheetState();
}

class _DeliveryChecklistSheetState extends State<DeliveryChecklistSheet> {
  // Checklist states
  bool _recipientVerified = false;
  bool _packageConditionChecked = false;
  bool _paymentCollected = false;
  bool _locationConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final isCod = widget.parcel.totalPrice > 0;

    // Check if all required steps are completed
    final bool allCompleted = _recipientVerified &&
        _packageConditionChecked &&
        _locationConfirmed &&
        (!isCod || _paymentCollected);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            tr.delivery_checklist,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr.complete_steps_to_proceed,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Checklist Items
          _buildChecklistItem(
            title: tr.verify_recipient,
            subtitle: widget.parcel.recipientName,
            value: _recipientVerified,
            onChanged: (val) =>
                setState(() => _recipientVerified = val ?? false),
          ),

          _buildChecklistItem(
            title: tr.confirm_location,
            subtitle: widget.parcel.deliveryAddress,
            value: _locationConfirmed,
            onChanged: (val) =>
                setState(() => _locationConfirmed = val ?? false),
          ),

          _buildChecklistItem(
            title: tr.check_package_condition,
            subtitle: tr.ensure_no_damage,
            value: _packageConditionChecked,
            onChanged: (val) =>
                setState(() => _packageConditionChecked = val ?? false),
          ),

          if (isCod)
            _buildChecklistItem(
              title: tr.collect_payment,
              subtitle: '₪${widget.parcel.totalPrice.toStringAsFixed(2)}',
              value: _paymentCollected,
              onChanged: (val) =>
                  setState(() => _paymentCollected = val ?? false),
              isHighPriority: true,
            ),

          const SizedBox(height: 32),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: allCompleted ? widget.onCompleted : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                tr.proceed_to_proof,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isHighPriority = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isHighPriority ? Colors.red[700] : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isHighPriority ? Colors.red[400] : Colors.grey[600],
          ),
        ),
        activeColor: AppStyles.primaryColor,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: value
                ? AppStyles.primaryColor.withOpacity(0.5)
                : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }
}
