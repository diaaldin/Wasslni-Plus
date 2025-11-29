import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/generated/l10n.dart';
import 'package:turoudi/provider/app_settings_providor.dart';
import 'package:turoudi/flow/common/privacy_policy/PrivacyPolicyPage.dart';
import 'package:turoudi/widgets/language/language_dropdown.dart';
import 'package:turoudi/widgets/log_in.dart';
import 'package:turoudi/widgets/molecules/custom_list_tile.dart';
import 'package:turoudi/widgets/molecules/custom_switch_tile.dart';

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  SettingsMainState createState() => SettingsMainState();
}

class SettingsMainState extends State<SettingsMain> {
  @override
  void initState() {
    super.initState();
  }

  void _onLanguageChanged(Locale newLocale) {
    final settingsModel =
        Provider.of<AppSettingsProvidor>(context, listen: false);
    settingsModel.changeLanguage(newLocale);
    // _saveUserPreferredLanguage(context, newLocale.languageCode);
  }

  // Future<void> _saveUserIsDarkMode(
  //     BuildContext context, bool isDarkMode) async {
  //   if (currentUser == null) return;

  //   try {
  //     await UserService().updateUser(currentUser!.id!, {
  //       "isDarkMode": isDarkMode,
  //     });
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(S.of(context).dark_mode_msg_successed)),
  //       );
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error updating dark mode $e')),
  //       );
  //     }
  //   }
  // }

  void _onIsDarkModeChanged(bool newIsDarkMode) {
    final appSettings =
        Provider.of<AppSettingsProvidor>(context, listen: false);
    appSettings.toggleDarkMode(); // Toggle the dark mode in settings
    // _saveUserIsDarkMode(
    //     context, newIsDarkMode); // Save the preference to Firebase
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<AppSettingsProvidor>(context);
    return Scaffold(
      body: ListView(
        padding: AppStyles.defaultPadding,
        children: [
          SwitchTileWidget(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            icon: settingsModel.isDarkMode
                ? Icons.dark_mode_outlined
                : Icons.wb_sunny_outlined,
            title: settingsModel.isDarkMode
                ? S.of(context).dark_mode
                : S.of(context).sunny_mode,
            color: AppStyles.primaryColor,
            value: settingsModel.isDarkMode,
            onChanged: (value) =>
                _onIsDarkModeChanged(value), // Pass value here
          ),
          CustomListTile(
            icon: Icons.language,
            title: S.of(context).language,
            color: AppStyles.primaryColor,
            trailingWidget: LanguageDropdown(
              onChanged: _onLanguageChanged,
            ),
          ),
          CustomListTile(
            icon: Icons.privacy_tip,
            title: S.of(context).privacy_policy,
            color: AppStyles.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
              );
            },
          ),
          CustomListTile(
            icon: Icons.logout,
            title: S.of(context).logout,
            color: AppStyles.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
