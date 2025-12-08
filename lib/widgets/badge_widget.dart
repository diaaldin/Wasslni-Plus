import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';

/// A widget that displays a badge with a count over another widget
/// Commonly used for showing notification counts
class BadgeWidget extends StatelessWidget {
  final Widget child;
  final int count;
  final Color? badgeColor;
  final Color? textColor;
  final bool showZero;

  const BadgeWidget({
    super.key,
    required this.child,
    required this.count,
    this.badgeColor,
    this.textColor,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show badge if count is 0 and showZero is false
    if (count == 0 && !showZero) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            decoration: BoxDecoration(
              color: badgeColor ?? Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/// A specialized notification badge that shows unread count
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int unreadCount;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      count: unreadCount,
      badgeColor: AppStyles.primaryColor,
      child: child,
    );
  }
}
