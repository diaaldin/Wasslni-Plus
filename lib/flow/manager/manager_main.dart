import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';

class ManagerMainScreen extends StatefulWidget {
  const ManagerMainScreen({super.key});

  @override
  State<ManagerMainScreen> createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Manager Main page')),
    Center(child: Text('Manager Pckages pages')),
    Center(child: Text('Manager Settings page')),
  ];

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            label: tr.main,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping_outlined),
            label: tr.parcels,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: tr.settings,
          ),
        ],
      ),
    );
  }
}
