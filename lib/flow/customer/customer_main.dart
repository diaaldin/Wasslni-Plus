import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';

import 'package:wasslni_plus/flow/customer/history/order_history_page.dart';
import 'package:wasslni_plus/flow/customer/dashboard/active_deliveries_view.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ActiveDeliveriesView(),
    OrderHistoryPage(),
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
