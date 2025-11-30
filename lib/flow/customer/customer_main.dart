import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Customer Main page')),
    Center(child: Text('Customer Pckages pages')),
    Center(child: Text('Customer Settings page')),
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
