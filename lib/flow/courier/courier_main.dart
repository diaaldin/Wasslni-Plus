import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/flow/courier/dashboard/courier_dashboard_page.dart';
import 'package:wasslni_plus/flow/courier/dashboard/active_deliveries_page.dart';
import 'package:wasslni_plus/flow/courier/profile/courier_profile_page.dart';

class CourierMainScreen extends StatefulWidget {
  const CourierMainScreen({super.key});

  @override
  State<CourierMainScreen> createState() => _CourierMainScreenState();
}

class _CourierMainScreenState extends State<CourierMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CourierDashboardPage(),
    ActiveDeliveriesPage(),
    CourierProfilePage(),
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
