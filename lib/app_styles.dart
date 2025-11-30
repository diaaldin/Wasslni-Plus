import 'package:flutter/material.dart';

class AppStyles {
  // Method to create a lighter or darker color
  static Color adjustColor(Color color,
      {double amount = 0.1, bool darken = false}) {
    final hslColor = HSLColor.fromColor(color);
    final adjustedLightness = darken
        ? (hslColor.lightness - amount).clamp(0.0, 1.0)
        : (hslColor.lightness + amount).clamp(0.0, 1.0);
    return hslColor.withLightness(adjustedLightness).toColor();
  }

  // Wasslni Plus Brand Colors
  static const Color darkSurfaceColor = Color(0xFF1A1A1A); // Darker surface for better contrast
  static const Color primaryColor =
      Color(0xFF00BCD4); // Vibrant Teal/Cyan - represents speed and reliability
  static const Color secondaryColor =
      Color(0xFFFF9800); // Vibrant Orange - represents energy and action

  static Color get primaryColor100 => adjustColor(primaryColor, amount: 0.3);
  static Color get primaryColor200 => adjustColor(primaryColor, amount: 0.2);
  static Color unSelectedColor = Colors.grey;
  static Color unSelectedColor100 = adjustColor(unSelectedColor, amount: 0.3);
  static Color unSelectedColor600 =
      adjustColor(unSelectedColor, amount: 0.3, darken: true);
  static const Color errorColor = Colors.red;
  static Color iconLogoutColor = adjustColor(errorColor, amount: 0.05);
  static const Color loaderColor = Colors.white;
  static Color btnDeleteColor = adjustColor(errorColor, amount: 0.1);

  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
  static const Color primaryTextColor = Colors.black87;
  static const Color transparentColor = Colors.transparent;

  static const Color waitingStatus = Colors.orange;
  static const Color doneStatus = primaryColor;
  static const Color cancelledStatus = errorColor;
  static const Color rescheduledStatus = Colors.blueGrey;
  static const Color rsetStatus = Colors.grey;
  // Sun color
  static const Color sunIconColor = Color(0xFFFFD700);
  static const Color nightIconColor = Colors.blueGrey;

  // Sun color
  static const Color languageIconColor = Colors.green;
  // Text Styles
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: primaryTextColor,
  );

  // Padding values
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);

  // sizes
  static const double iconSize = 24.0;
  static const double sSize = 12;
  static const double mSize = 14;
  static const double lSize = 16;
  static const double xlSize = 18;
}
