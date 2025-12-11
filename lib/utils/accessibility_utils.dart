import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities for making the app usable by everyone
///
/// This utility class provides helpers for:
/// - Screen reader support (TalkBack, VoiceOver)
/// - Semantic labels and hints
/// - Focus management
/// - Accessible touch targets
/// - Text scaling support

class AccessibilityUtils {
  // Prevent instantiation
  AccessibilityUtils._();

  // ============================================================================
  // CONSTANTS
  // ============================================================================

  /// Minimum touch target size (48x48 dp) as per Material Design guidelines
  static const double minTouchTargetSize = 48.0;

  /// Recommended touch target size for better accessibility (56x56 dp)
  static const double recommendedTouchTargetSize = 56.0;

  /// Maximum text scale factor to support
  static const double maxTextScaleFactor = 2.0;

  // ============================================================================
  // SCREEN READER DETECTION
  // ============================================================================

  /// Check if screen reader is currently enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.accessibleNavigation;
  }

  /// Check if user has requested bold text
  static bool isBoldTextEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.boldText;
  }

  /// Get current text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Check if text scaling is enabled (factor > 1.0)
  static bool isTextScalingEnabled(BuildContext context) {
    return getTextScaleFactor(context) > 1.0;
  }

  // ============================================================================
  // SEMANTIC HELPERS
  // ============================================================================

  /// Create a semantic label for a widget
  ///
  /// Example:
  /// ```dart
  /// Semantics(
  ///   label: AccessibilityUtils.createSemanticLabel('Add parcel'),
  ///   child: IconButton(icon: Icon(Icons.add)),
  /// )
  /// ```
  static String createSemanticLabel(String label, {String? hint}) {
    if (hint != null && hint.isNotEmpty) {
      return '$label. $hint';
    }
    return label;
  }

  /// Create a semantic value label (e.g., for sliders, progress bars)
  static String createValueLabel(String label, dynamic value, {String? unit}) {
    if (unit != null && unit.isNotEmpty) {
      return '$label: $value $unit';
    }
    return '$label: $value';
  }

  /// Create a semantic button label
  static String createButtonLabel(String action, {String? target}) {
    if (target != null && target.isNotEmpty) {
      return '$action $target';
    }
    return action;
  }

  // ============================================================================
  // FOCUS MANAGEMENT
  // ============================================================================

  /// Request focus on a specific node
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// Move focus to next focusable widget
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to previous focusable widget
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocus current widget
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // ============================================================================
  // TOUCH TARGET SIZING
  // ============================================================================

  /// Ensure a widget meets minimum touch target size
  ///
  /// Example:
  /// ```dart
  /// AccessibilityUtils.ensureTouchTarget(
  ///   child: Icon(Icons.delete, size: 20),
  /// )
  /// ```
  static Widget ensureTouchTarget({
    required Widget child,
    double minSize = minTouchTargetSize,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: Center(child: child),
    );
  }

  /// Get appropriate padding to achieve minimum touch target size
  static EdgeInsets getTouchTargetPadding({
    required Size currentSize,
    double minSize = minTouchTargetSize,
  }) {
    final horizontalPadding = (minSize - currentSize.width) / 2;
    final verticalPadding = (minSize - currentSize.height) / 2;

    return EdgeInsets.symmetric(
      horizontal: horizontalPadding > 0 ? horizontalPadding : 0,
      vertical: verticalPadding > 0 ? verticalPadding : 0,
    );
  }

  // ============================================================================
  // TEXT SCALING
  // ============================================================================

  /// Clamp text scale factor to a maximum value to prevent overflow
  static double clampTextScaleFactor(
    BuildContext context, {
    double max = maxTextScaleFactor,
  }) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return scaleFactor.clamp(1.0, max);
  }

  /// Create MediaQueryData with clamped text scale factor
  static MediaQueryData clampedMediaQuery(
    BuildContext context, {
    double max = maxTextScaleFactor,
  }) {
    final data = MediaQuery.of(context);
    final clampedScale = data.textScaleFactor.clamp(1.0, max);

    return data.copyWith(textScaleFactor: clampedScale);
  }

  /// Wrap a widget with clamped text scaling
  ///
  /// Example:
  /// ```dart
  /// AccessibilityUtils.withClampedTextScale(
  ///   context: context,
  ///   child: Text('This text won\'t scale beyond 2x'),
  /// )
  /// ```
  static Widget withClampedTextScale({
    required BuildContext context,
    required Widget child,
    double max = maxTextScaleFactor,
  }) {
    return MediaQuery(
      data: clampedMediaQuery(context, max: max),
      child: child,
    );
  }

  // ============================================================================
  // CONTRAST CHECKING
  // ============================================================================

  /// Calculate relative luminance of a color (WCAG standard)
  static double calculateLuminance(Color color) {
    // WCAG 2.0 formula
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;

    r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors (WCAG standard)
  static double calculateContrastRatio(Color color1, Color color2) {
    final lum1 = calculateLuminance(color1);
    final lum2 = calculateLuminance(color2);

    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast ratio meets WCAG AA standard (4.5:1 for normal text)
  static bool meetsWCAG_AA(Color foreground, Color background) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= 4.5;
  }

  /// Check if contrast ratio meets WCAG AAA standard (7:1 for normal text)
  static bool meetsWCAG_AAA(Color foreground, Color background) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= 7.0;
  }

  /// Check if contrast ratio meets WCAG AA for large text (3:1)
  static bool meetsWCAG_AA_LargeText(Color foreground, Color background) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= 3.0;
  }

  // ============================================================================
  // ANNOUNCEMENTS (Screen Reader)
  // ============================================================================

  /// Announce a message to screen readers
  ///
  /// Example:
  /// ```dart
  /// AccessibilityUtils.announce(context, 'Parcel added successfully');
  /// ```
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce with specific text direction (for RTL support)
  static void announceWithDirection(
    BuildContext context,
    String message,
    TextDirection direction,
  ) {
    SemanticsService.announce(message, direction);
  }

  // ============================================================================
  // HELPER WIDGETS
  // ============================================================================

  /// Create an accessible button with proper semantics
  static Widget accessibleButton({
    required String label,
    required VoidCallback onPressed,
    String? hint,
    Widget? child,
  }) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      onTap: onPressed,
      child: child,
    );
  }

  /// Create an accessible icon with label
  static Widget accessibleIcon({
    required IconData icon,
    required String label,
    Color? color,
    double? size,
  }) {
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Icon(icon, color: color, size: size),
      ),
    );
  }

  /// Create an accessible image with description
  static Widget accessibleImage({
    required String description,
    required Widget image,
  }) {
    return Semantics(
      image: true,
      label: description,
      child: ExcludeSemantics(child: image),
    );
  }
}

/// Widget that ensures minimum touch target size
class AccessibleTouchTarget extends StatelessWidget {
  final Widget child;
  final double minSize;

  const AccessibleTouchTarget({
    super.key,
    required this.child,
    this.minSize = AccessibilityUtils.minTouchTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibilityUtils.ensureTouchTarget(
      child: child,
      minSize: minSize,
    );
  }
}

/// Widget that clamps text scaling to prevent overflow
class ClampedTextScale extends StatelessWidget {
  final Widget child;
  final double maxScale;

  const ClampedTextScale({
    super.key,
    required this.child,
    this.maxScale = AccessibilityUtils.maxTextScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibilityUtils.withClampedTextScale(
      context: context,
      child: child,
      max: maxScale,
    );
  }
}

/// Helper function for math power (since dart:math import would be needed)
double pow(double x, double exponent) {
  if (exponent == 0) return 1;
  if (exponent == 1) return x;

  double result = x;
  for (int i = 1; i < exponent.abs(); i++) {
    result *= x;
  }

  if (exponent < 0) {
    return 1 / result;
  }
  return result;
}
