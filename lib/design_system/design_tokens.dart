import 'package:flutter/material.dart';

/// Wasslni Plus Design System
/// Comprehensive design tokens for consistent UI/UX across the app

class DesignSystem {
  // Prevent instantiation
  DesignSystem._();

  // ============================================================================
  // COLOR TOKENS
  // ============================================================================

  /// Primary Brand Colors
  static const Color primaryColor = Color(0xFFE91E63); // Pink
  static const Color primaryLight = Color(0xFFF8BBD0);
  static const Color primaryDark = Color(0xFFC2185B);

  /// Secondary Colors
  static const Color secondaryColor = Color(0xFF2196F3); // Blue
  static const Color secondaryLight = Color(0xFFBBDEFB);
  static const Color secondaryDark = Color(0xFF1976D2);

  /// Neutral Colors (Grayscale)
  static const Color neutral900 = Color(0xFF212121); // Darkest
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral50 = Color(0xFFFAFAFA); // Lightest

  /// Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color error = Color(0xFFF44336); // Red
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3); // Blue
  static const Color infoLight = Color(0xFFBBDEFB);
  static const Color infoDark = Color(0xFF1976D2);

  /// Status Colors
  static const Color statusPending = Color(0xFFFF9800); // Orange
  static const Color statusInProgress = Color(0xFF2196F3); // Blue
  static const Color statusCompleted = Color(0xFF4CAF50); // Green
  static const Color statusCancelled = Color(0xFF9E9E9E); // Gray
  static const Color statusReturned = Color(0xFFF44336); // Red

  /// Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = Color(0xFFF5F5F5); // Light gray
  static const Color backgroundTertiary = Color(0xFFEEEEEE); // Lighter gray

  /// Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDefault = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFFF5F5F5);

  /// Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ============================================================================
  // SPACING TOKENS
  // ============================================================================

  /// Base spacing unit (4px)
  static const double spaceUnit = 4.0;

  /// Spacing scale (based on 4px unit)
  static const double space0 = 0.0;
  static const double space1 = spaceUnit * 1; // 4px
  static const double space2 = spaceUnit * 2; // 8px
  static const double space3 = spaceUnit * 3; // 12px
  static const double space4 = spaceUnit * 4; // 16px
  static const double space5 = spaceUnit * 5; // 20px
  static const double space6 = spaceUnit * 6; // 24px
  static const double space8 = spaceUnit * 8; // 32px
  static const double space10 = spaceUnit * 10; // 40px
  static const double space12 = spaceUnit * 12; // 48px
  static const double space16 = spaceUnit * 16; // 64px
  static const double space20 = spaceUnit * 20; // 80px

  /// Semantic spacing
  static const double paddingXSmall = space2; // 8px
  static const double paddingSmall = space3; // 12px
  static const double paddingMedium = space4; // 16px
  static const double paddingLarge = space6; // 24px
  static const double paddingXLarge = space8; // 32px

  static const double marginXSmall = space2; // 8px
  static const double marginSmall = space3; // 12px
  static const double marginMedium = space4; // 16px
  static const double marginLarge = space6; // 24px
  static const double marginXLarge = space8; // 32px

  // ============================================================================
  // TYPOGRAPHY TOKENS
  // ============================================================================

  /// Font Families
  static const String fontFamilyPrimary = 'Roboto';
  static const String fontFamilyArabic = 'Cairo';

  /// Font Sizes
  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize48 = 48.0;

  /// Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  /// Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 2.0;

  /// Text Styles
  static const TextStyle h1 = TextStyle(
    fontSize: fontSize48,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    color: textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: fontSize36,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    color: textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: fontSize28,
    fontWeight: fontWeightBold,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: fontSize24,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: fontSize20,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: fontSize18,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSize18,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSize16,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSize14,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSize12,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontSize: fontSize10,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    color: textSecondary,
    letterSpacing: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: fontSize16,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: 0.5,
  );

  // ============================================================================
  // BORDER RADIUS TOKENS
  // ============================================================================

  static const double radiusNone = 0.0;
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusFull = 9999.0; // Circular

  static BorderRadius get borderRadiusSmall =>
      BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium =>
      BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge =>
      BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusXLarge =>
      BorderRadius.circular(radiusXLarge);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // ============================================================================
  // ELEVATION/SHADOW TOKENS
  // ============================================================================

  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
  static const double elevation16 = 16.0;
  static const double elevation24 = 24.0;

  /// Box Shadow presets
  static List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLarge => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowXLarge => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // ============================================================================
  // ANIMATION TOKENS
  // ============================================================================

  /// Duration tokens (milliseconds)
  static const int durationQuick = 150;
  static const int durationNormal = 300;
  static const int durationSlow = 500;

  /// Duration as Duration objects
  static const Duration animationQuick = Duration(milliseconds: durationQuick);
  static const Duration animationNormal =
      Duration(milliseconds: durationNormal);
  static const Duration animationSlow = Duration(milliseconds: durationSlow);

  /// Animation curves
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveLinear = Curves.linear;

  // ============================================================================
  // SIZING TOKENS
  // ============================================================================

  /// Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  /// Button sizes
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightLarge = 48.0;

  /// Input field sizes
  static const double inputHeightSmall = 36.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;

  /// Container constraints
  static const double containerMaxWidthSmall = 400.0;
  static const double containerMaxWidthMedium = 600.0;
  static const double containerMaxWidthLarge = 800.0;
  static const double containerMaxWidthXLarge = 1200.0;

  // ============================================================================
  // BREAKPOINTS (for responsive design)
  // ============================================================================

  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;
  static const double breakpointWide = 1800.0;

  /// Helper method to check device size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointDesktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }

  // ============================================================================
  // Z-INDEX LAYERS
  // ============================================================================

  static const int zIndexBase = 0;
  static const int zIndexDropdown = 1000;
  static const int zIndexSticky = 1100;
  static const int zIndexFixed = 1200;
  static const int zIndexModalBackdrop = 1300;
  static const int zIndexModal = 1400;
  static const int zIndexPopover = 1500;
  static const int zIndexTooltip = 1600;
  static const int zIndexNotification = 1700;
}
