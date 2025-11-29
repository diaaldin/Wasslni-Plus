import 'package:flutter/material.dart';

class SwitchTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool value;
  final Function(bool) onChanged;
  final EdgeInsets margin;

  const SwitchTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.value,
    required this.onChanged,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: SwitchListTile(
        secondary: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }
}
