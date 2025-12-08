import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/flow/common/settings/settings_main.dart';
import 'package:wasslni_plus/flow/merchant/dashboard/merchant_dashboard_page.dart';
import 'package:wasslni_plus/flow/merchant/notifications/merchant_notifications_page.dart';
import 'package:wasslni_plus/flow/merchant/parcel/add_paracel_page.dart';
import 'package:wasslni_plus/flow/merchant/parcel/merchant_parcels_page.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/provider/app_settings_providor.dart';
import 'package:wasslni_plus/widgets/molecules/bottom_tab_item.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/firestore_service.dart';

class MerchantMainScreen extends StatefulWidget {
  const MerchantMainScreen({super.key});

  @override
  State<MerchantMainScreen> createState() => _MerchantMainScreenState();
}

class _MerchantMainScreenState extends State<MerchantMainScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

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
    final user = _authService.currentUser;

    final List<Widget> tabs = [
      const MerchantDashboardPage(),
      const MerchantParcelsPage(),
      const MerchantNotificationsPage(),
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
                // Notifications tab with badge
                if (user != null)
                  StreamBuilder<int>(
                    stream: _firestoreService
                        .streamUnreadNotificationCount(user.uid),
                    builder: (context, snapshot) {
                      final unreadCount = snapshot.data ?? 0;
                      return BottomTabItem(
                        index: 2,
                        selectedIndex: _selectedIndex,
                        icon: Icons.notifications_none_outlined,
                        label: tr.notifications,
                        badgeCount: unreadCount,
                        onTap: () => setState(() => _selectedIndex = 2),
                      );
                    },
                  ),
                if (user == null)
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
