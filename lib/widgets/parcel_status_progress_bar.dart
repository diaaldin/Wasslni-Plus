import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:intl/intl.dart';

class ParcelStatusProgressBar extends StatefulWidget {
  final ParcelStatus currentStatus;
  final List<StatusHistory> statusHistory;
  final bool showTimestamps;
  final bool isExpandable;

  const ParcelStatusProgressBar({
    super.key,
    required this.currentStatus,
    required this.statusHistory,
    this.showTimestamps = true,
    this.isExpandable = true,
  });

  @override
  State<ParcelStatusProgressBar> createState() =>
      _ParcelStatusProgressBarState();
}

class _ParcelStatusProgressBarState extends State<ParcelStatusProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  // Define the status flow order
  static const List<ParcelStatus> _statusFlow = [
    ParcelStatus.awaitingLabel,
    ParcelStatus.readyToShip,
    ParcelStatus.enRouteDistributor,
    ParcelStatus.atWarehouse,
    ParcelStatus.outForDelivery,
    ParcelStatus.delivered,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    // Handle special statuses (returned/cancelled)
    if (widget.currentStatus == ParcelStatus.returned ||
        widget.currentStatus == ParcelStatus.cancelled) {
      return _buildSpecialStatusCard(tr);
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.parcel_status,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.isExpandable)
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                  ),
              ],
            ),
          ),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildProgressBar(),
          ),

          // Current status
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCurrentStatusChip(tr),
          ),

          // Expandable details
          if (_isExpanded && widget.showTimestamps) _buildExpandedDetails(tr),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final currentIndex = _statusFlow.indexOf(widget.currentStatus);

    return FadeTransition(
      opacity: _animation,
      child: Column(
        children: [
          Row(
            children: List.generate(
              _statusFlow.length,
              (index) => Expanded(
                child: _buildStatusStep(index, currentIndex),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _statusFlow.map((status) {
              final index = _statusFlow.indexOf(status);
              final isCompleted = index <= currentIndex;
              return Expanded(
                child: _buildStatusIcon(
                    status, isCompleted, index == currentIndex),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(int index, int currentIndex) {
    final isCompleted = index <= currentIndex;
    final isFirst = index == 0;

    return Row(
      children: [
        // Don't show line before first item
        if (!isFirst)
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: isCompleted ? AppStyles.primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusIcon(
      ParcelStatus status, bool isCompleted, bool isCurrent) {
    final icon = _getStatusIcon(status);
    final color = isCompleted ? AppStyles.primaryColor : Colors.grey[400]!;

    return Column(
      children: [
        ScaleTransition(
          scale: isCurrent
              ? Tween<double>(begin: 0.8, end: 1.0).animate(_animation)
              : const AlwaysStoppedAnimation(1.0),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppStyles.primaryColor
                  : (isCompleted
                      ? AppStyles.primaryColor.withAlpha(50)
                      : Colors.grey[200]),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: isCurrent ? 3 : 2,
              ),
            ),
            child: Icon(
              icon,
              color: isCurrent ? Colors.white : color,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getStatusShortLabel(status),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? AppStyles.primaryColor : Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCurrentStatusChip(S tr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppStyles.primaryColor.withAlpha(100),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(widget.currentStatus),
            color: AppStyles.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusLabel(widget.currentStatus, tr),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppStyles.primaryColor,
                  ),
                ),
                if (widget.statusHistory.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(widget.statusHistory.last.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedDetails(S tr) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.status_history,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.statusHistory.reversed.map((history) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    decoration: const BoxDecoration(
                      color: AppStyles.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusLabel(history.status, tr),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTimestamp(history.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (history.notes != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            history.notes!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSpecialStatusCard(S tr) {
    final isReturned = widget.currentStatus == ParcelStatus.returned;
    final color = isReturned ? Colors.orange : Colors.red;
    final icon = isReturned ? Icons.undo : Icons.cancel;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStatusLabel(widget.currentStatus, tr),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.statusHistory.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _formatTimestamp(widget.statusHistory.last.timestamp),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
            if (widget.isExpandable) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                label: Text(_isExpanded ? tr.hide_details : tr.show_details),
              ),
            ],
            if (_isExpanded) _buildExpandedDetails(tr),
          ],
        ),
      ),
    );
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

  String _getStatusShortLabel(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return 'Label';
      case ParcelStatus.readyToShip:
        return 'Ready';
      case ParcelStatus.enRouteDistributor:
        return 'En Route';
      case ParcelStatus.atWarehouse:
        return 'Warehouse';
      case ParcelStatus.outForDelivery:
        return 'Delivery';
      case ParcelStatus.delivered:
        return 'Delivered';
      case ParcelStatus.returned:
        return 'Returned';
      case ParcelStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, y - h:mm a').format(timestamp);
  }
}
