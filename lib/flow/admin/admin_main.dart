import 'package:flutter/material.dart';
import 'package:wasslni_plus/flow/admin/parcels/admin_parcels_page.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/flow/shared/user_settings_page.dart';
import 'package:wasslni_plus/flow/admin/dashboard/admin_dashboard_page.dart';

import 'package:wasslni_plus/flow/admin/couriers/admin_couriers_page.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardPage(),
    const AdminParcelsPage(),
    const AdminCouriersPage(),
    const UserSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // Added for >3 items
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
            icon: const Icon(Icons.people_outline),
            label: tr.couriers,
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
