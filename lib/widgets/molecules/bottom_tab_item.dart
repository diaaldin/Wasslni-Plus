import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/widgets/badge_widget.dart';

class BottomTabItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int? badgeCount;

  const BottomTabItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    // Icon widget with optional badge
    final iconWidget = Icon(
      icon,
      color: isSelected ? AppStyles.primaryColor : AppStyles.unSelectedColor,
    );

    final iconWithBadge = badgeCount != null && badgeCount! > 0
        ? NotificationBadge(
            unreadCount: badgeCount!,
            child: iconWidget,
          )
        : iconWidget;

    return MaterialButton(
      minWidth: 40,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWithBadge,
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppStyles.primaryColor
                  : AppStyles.unSelectedColor,
              fontSize: AppStyles.sSize,
            ),
          ),
        ],
      ),
    );
  }
}
