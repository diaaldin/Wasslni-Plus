import 'package:flutter/material.dart';
import 'package:wasslni_plus/design_system/design_tokens.dart';

/// Responsive utilities for building adaptive layouts
///
/// This utility class provides helpers for:
/// - Building responsive layouts based on screen size
/// - Handling different device types (mobile, tablet, desktop)
/// - Managing landscape and portrait orientations
/// - Adaptive spacing and sizing

class ResponsiveUtils {
  // Prevent instantiation
  ResponsiveUtils._();

  // ============================================================================
  // DEVICE TYPE DETECTION
  // ============================================================================

  /// Returns true if the device is mobile (width < 600)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < DesignSystem.breakpointMobile;
  }

  /// Returns true if the device is tablet (600 <= width < 1200)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= DesignSystem.breakpointMobile &&
        width < DesignSystem.breakpointDesktop;
  }

  /// Returns true if the device is desktop (width >= 1200)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= DesignSystem.breakpointDesktop;
  }

  /// Returns true if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Returns true if the device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // ============================================================================
  // SCREEN SIZE GETTERS
  // ============================================================================

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // ============================================================================
  // RESPONSIVE BUILDERS
  // ============================================================================

  /// Build different widgets based on device type
  ///
  /// Example:
  /// ```dart
  /// ResponsiveUtils.buildResponsive(
  ///   context: context,
  ///   mobile: MobileLayout(),
  ///   tablet: TabletLayout(),
  ///   desktop: DesktopLayout(),
  /// )
  /// ```
  static Widget buildResponsive({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Build widget based on a value function for each device type
  ///
  /// Example:
  /// ```dart
  /// ResponsiveUtils.value<int>(
  ///   context: context,
  ///   mobile: 1,
  ///   tablet: 2,
  ///   desktop: 3,
  /// )
  /// ```
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // ============================================================================
  // ADAPTIVE SIZING
  // ============================================================================

  /// Get responsive padding based on screen size
  static double responsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return DesignSystem.paddingXLarge;
    } else if (isTablet(context)) {
      return DesignSystem.paddingLarge;
    } else {
      return DesignSystem.paddingMedium;
    }
  }

  /// Get responsive horizontal padding
  static double responsiveHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return DesignSystem.space12; // 48px
    } else if (isTablet(context)) {
      return DesignSystem.space8; // 32px
    } else {
      return DesignSystem.space4; // 16px
    }
  }

  /// Get responsive vertical padding
  static double responsiveVerticalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return DesignSystem.space8; // 32px
    } else if (isTablet(context)) {
      return DesignSystem.space6; // 24px
    } else {
      return DesignSystem.space4; // 16px
    }
  }

  /// Get responsive font size multiplier
  static double responsiveFontSize(BuildContext context, double baseSize) {
    if (isDesktop(context)) {
      return baseSize * 1.1;
    } else if (isTablet(context)) {
      return baseSize * 1.05;
    } else {
      return baseSize;
    }
  }

  /// Get responsive icon size
  static double responsiveIconSize(BuildContext context) {
    if (isDesktop(context)) {
      return DesignSystem.iconSizeLarge;
    } else if (isTablet(context)) {
      return DesignSystem.iconSizeMedium;
    } else {
      return DesignSystem.iconSizeMedium;
    }
  }

  // ============================================================================
  // GRID LAYOUT HELPERS
  // ============================================================================

  /// Get number of columns for grid layouts based on screen size
  static int gridCrossAxisCount(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Get child aspect ratio for grid tiles based on screen size
  static double gridChildAspectRatio(
    BuildContext context, {
    double mobile = 1.0,
    double tablet = 1.2,
    double desktop = 1.5,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // ============================================================================
  // CONTAINER CONSTRAINTS
  // ============================================================================

  /// Get max width for content containers
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return DesignSystem.containerMaxWidthXLarge;
    } else if (isTablet(context)) {
      return DesignSystem.containerMaxWidthLarge;
    } else {
      return double.infinity;
    }
  }

  /// Build a centered container with max width constraint
  static Widget centeredConstrainedContainer({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }

  // ============================================================================
  // ORIENTATION HELPERS
  // ============================================================================

  /// Get number of columns based on orientation and device type
  static int columnsForOrientation(BuildContext context) {
    if (isLandscape(context)) {
      if (isMobile(context)) return 2;
      if (isTablet(context)) return 3;
      return 4;
    } else {
      if (isMobile(context)) return 1;
      if (isTablet(context)) return 2;
      return 3;
    }
  }

  /// Get aspect ratio based on orientation
  static double aspectRatioForOrientation(BuildContext context) {
    return isLandscape(context) ? 16 / 9 : 4 / 3;
  }

  // ============================================================================
  // DIALOG/MODAL SIZING
  // ============================================================================

  /// Get responsive dialog width
  static double dialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isDesktop(context)) {
      return screenWidth * 0.4;
    } else if (isTablet(context)) {
      return screenWidth * 0.6;
    } else {
      return screenWidth * 0.9;
    }
  }

  /// Get responsive dialog max height
  static double dialogMaxHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.8;
  }

  // ============================================================================
  // LIST/CARD LAYOUT HELPERS
  // ============================================================================

  /// Determine if list items should be displayed in a compact layout
  static bool shouldUseCompactLayout(BuildContext context) {
    return isMobile(context) && isPortrait(context);
  }

  /// Get appropriate card elevation based on device
  static double cardElevation(BuildContext context) {
    if (isDesktop(context)) {
      return DesignSystem.elevation2;
    } else {
      return DesignSystem.elevation1;
    }
  }
}

/// Responsive widget that rebuilds when screen size or orientation changes
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return builder(context, constraints);
          },
        );
      },
    );
  }
}

/// Adaptive padding that changes based on screen size
class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const AdaptivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.value<EdgeInsets>(
      context: context,
      mobile: mobile ?? const EdgeInsets.all(DesignSystem.paddingMedium),
      tablet: tablet ?? const EdgeInsets.all(DesignSystem.paddingLarge),
      desktop: desktop ?? const EdgeInsets.all(DesignSystem.paddingXLarge),
    );

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Adaptive grid view that adjusts columns based on screen size
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double? childAspectRatio;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.gridCrossAxisCount(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    );

    return GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio ?? 1.0,
      children: children,
    );
  }
}
