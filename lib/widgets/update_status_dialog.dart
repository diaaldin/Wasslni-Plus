import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

/// Dialog/BottomSheet for updating parcel status
/// Example usage:
/// ```dart
/// await showUpdateStatusDialog(
///   context: context,
///   parcel: parcel,
///   newStatus: ParcelStatus.readyToShip,
/// );
/// ```
class UpdateStatusDialog extends StatefulWidget {
  final ParcelModel parcel;
  final ParcelStatus newStatus;
  final String? suggestedLocation;

  const UpdateStatusDialog({
    super.key,
    required this.parcel,
    required this.newStatus,
    this.suggestedLocation,
  });

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  final _reasonController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    if (widget.suggestedLocation != null) {
      _locationController.text = widget.suggestedLocation!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  bool _requiresReason() {
    return widget.newStatus == ParcelStatus.returned ||
        widget.newStatus == ParcelStatus.cancelled;
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getStatusIcon(widget.newStatus),
            color: AppStyles.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tr.update_status,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current status
              Text(
                '${tr.current_status}:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getStatusLabel(widget.parcel.status, tr),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // New status
              Text(
                '${tr.new_status}:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppStyles.primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppStyles.primaryColor.withAlpha(100),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(widget.newStatus),
                      color: AppStyles.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getStatusLabel(widget.newStatus, tr),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppStyles.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Location (optional for most statuses)
              if (widget.newStatus != ParcelStatus.awaitingLabel)
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: tr.location,
                    hintText: tr.enter_location,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
              if (widget.newStatus != ParcelStatus.awaitingLabel)
                const SizedBox(height: 16),

              // Reason (required for returned/cancelled)
              if (_requiresReason())
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: widget.newStatus == ParcelStatus.returned
                        ? tr.return_reason
                        : tr.cancellation_reason,
                    hintText: tr.enter_reason,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.info_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return tr.validation_required;
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
              if (_requiresReason()) const SizedBox(height: 16),

              // Notes (always optional)
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: tr.notes,
                  hintText: tr.add_notes_optional,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUpdating ? null : () => Navigator.pop(context),
          child: Text(tr.cancel),
        ),
        ElevatedButton(
          onPressed: _isUpdating ? null : _updateStatus,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.primaryColor,
          ),
          child: _isUpdating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(tr.update),
        ),
      ],
    );
  }

  Future<void> _updateStatus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      await _firestoreService.updateParcelStatus(
        widget.parcel.id!,
        widget.newStatus,
        currentUser.uid,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        reason: _reasonController.text.trim().isEmpty
            ? null
            : _reasonController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).status_updated_successfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getStatusIcon(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return Icons.label_outline;
      case ParcelStatus.readyToShip:
        return Icons.inventory_2_outlined;
      case ParcelStatus.enRouteDistributor:
        return Icons.local_shipping_outlined;
      case ParcelStatus.atWarehouse:
        return Icons.warehouse_outlined;
      case ParcelStatus.outForDelivery:
        return Icons.delivery_dining;
      case ParcelStatus.delivered:
        return Icons.check_circle;
      case ParcelStatus.returned:
        return Icons.undo;
      case ParcelStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusLabel(ParcelStatus status, S tr) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return tr.status_awaiting_label;
      case ParcelStatus.readyToShip:
        return tr.status_ready_to_ship;
      case ParcelStatus.enRouteDistributor:
        return tr.status_en_route_distributor;
      case ParcelStatus.atWarehouse:
        return tr.status_at_warehouse;
      case ParcelStatus.outForDelivery:
        return tr.status_out_for_delivery;
      case ParcelStatus.delivered:
        return tr.status_delivered;
      case ParcelStatus.returned:
        return tr.status_returned;
      case ParcelStatus.cancelled:
        return tr.status_cancelled;
    }
  }
}

/// Helper function to show the status update dialog
Future<bool?> showUpdateStatusDialog({
  required BuildContext context,
  required ParcelModel parcel,
  required ParcelStatus newStatus,
  String? suggestedLocation,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => UpdateStatusDialog(
      parcel: parcel,
      newStatus: newStatus,
      suggestedLocation: suggestedLocation,
    ),
  );
}

/// Alternative: Show as bottom sheet (better for mobile)
Future<bool?> showUpdateStatusBottomSheet({
  required BuildContext context,
  required ParcelModel parcel,
  required ParcelStatus newStatus,
  String? suggestedLocation,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: UpdateStatusDialog(
        parcel: parcel,
        newStatus: newStatus,
        suggestedLocation: suggestedLocation,
      ),
    ),
  );
}
