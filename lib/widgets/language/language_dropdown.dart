import 'package:flutter/material.dart';
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/widgets/language/constants.dart';

class LanguageDropdown extends StatelessWidget {
  final void Function(Locale) onChanged;

  const LanguageDropdown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: AppStyles.primaryColor,
        ),
        iconSize: AppStyles.iconSize,
        dropdownColor: Theme.of(context).brightness == Brightness.dark
            ? AppStyles.darkSurfaceColor
            : AppStyles.primaryColor100,
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            onChanged(newLocale);
          }
        },
        items: List.generate(
          supportedLocales.length,
          (index) => DropdownMenuItem<Locale>(
            value: supportedLocales[index],
            child: Text(
              localeNames[index],
            ),
          ),
        ),
      ),
    );
  }
}
