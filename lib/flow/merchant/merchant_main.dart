import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/flow/common/settings/settings_main.dart';
import 'package:turoudi/flow/merchant/parcel/add_paracel_page.dart';
import 'package:turoudi/flow/merchant/parcel/merchant_parcels_page.dart';
import 'package:turoudi/generated/l10n.dart';
import 'package:turoudi/provider/app_settings_providor.dart';
import 'package:turoudi/widgets/molecules/bottom_tab_item.dart';

class MerchantMainScreen extends StatefulWidget {
  const MerchantMainScreen({super.key});

  @override
  State<MerchantMainScreen> createState() => _MerchantMainScreenState();
}

class _MerchantMainScreenState extends State<MerchantMainScreen> {
  int _selectedIndex = 0;

  void _applyUserSettings() {
    //UserModel user
    final appSettings =
        Provider.of<AppSettingsProvidor>(context, listen: false);
    appSettings.changeLanguage(const Locale('ar')); // we should remove it
    // if (user.preferredLanguage != null) {
    // appSettings.changeLanguage(Locale(user.preferredLanguage!));
    // }

    // if (user.isDarkMode != null &&
    //     user.isDarkMode != appSettings.isDarkMode) {
    // appSettings.toggleDarkMode();
    // }
  }

  Future<void> _fetchCurrentUser() async {
    setState(() {});
    _applyUserSettings();
    // try {
    //   final user = await UserService().getCurrentUserDetails();
    //   await UserService().updateLastLoginTime(user.id!);
    //   setState(() => currentUser = user);
    //   _applyUserSettings(user);
    // } catch (e) {
    //   debugPrint('Error fetching user: $e');
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content: Text('Failed to fetch current user details.')),
    //     );
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    final List<Widget> tabs = [
      const Center(child: Text('Merchant Main page')),
      const MerchantParcelsPage(),
      const Center(child: Text('Merchant Notifications page')),
      const SettingsMain(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColor,
        title: Text(S.of(context).merchant_dashboard),
      ),
      body: tabs[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddParcelPage()),
          );
        },
        backgroundColor: AppStyles.primaryColor,
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                BottomTabItem(
                  index: 0,
                  selectedIndex: _selectedIndex,
                  icon: Icons.dashboard_outlined,
                  label: tr.main,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                BottomTabItem(
                  index: 1,
                  selectedIndex: _selectedIndex,
                  icon: Icons.local_shipping_outlined,
                  label: tr.parcels,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
            Row(
              children: [
                BottomTabItem(
                  index: 2,
                  selectedIndex: _selectedIndex,
                  icon: Icons.notifications_none_outlined,
                  label: tr.notifications,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                BottomTabItem(
                  index: 3,
                  selectedIndex: _selectedIndex,
                  icon: Icons.settings,
                  label: tr.settings,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
