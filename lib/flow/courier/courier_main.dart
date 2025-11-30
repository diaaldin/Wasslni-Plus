import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';

class CourierMainScreen extends StatefulWidget {
  const CourierMainScreen({super.key});

  @override
  State<CourierMainScreen> createState() => _CourierMainScreenState();
}

class _CourierMainScreenState extends State<CourierMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Courier Main page')),
    Center(child: Text('Courier Pckages pages')),
    Center(child: Text('Courier Settings page')),
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
