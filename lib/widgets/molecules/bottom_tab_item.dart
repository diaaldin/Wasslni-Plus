import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';

class BottomTabItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BottomTabItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return MaterialButton(
      minWidth: 40,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isSelected ? AppStyles.primaryColor : AppStyles.unSelectedColor,
          ),
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
