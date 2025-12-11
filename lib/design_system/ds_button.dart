import 'package:flutter/material.dart';
import 'package:wasslni_plus/design_system/design_tokens.dart';

/// Reusable Button Component with Design System tokens
class DSButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final DSButtonVariant variant;
  final DSButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const DSButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = DSButtonVariant.primary,
    this.size = DSButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();

    Widget button = icon != null
        ? ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? SizedBox(
                    width: DesignSystem.iconSizeSmall,
                    height: DesignSystem.iconSizeSmall,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(icon, size: _getIconSize()),
            label: Text(text, style: textStyle),
            style: buttonStyle,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: isLoading
                ? SizedBox(
                    width: DesignSystem.iconSizeSmall,
                    height: DesignSystem.iconSizeSmall,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(text, style: textStyle),
          );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  ButtonStyle _getButtonStyle() {
    final colors = _getColors();

    return ElevatedButton.styleFrom(
      backgroundColor: colors.$1,
      foregroundColor: colors.$2,
      elevation: variant == DSButtonVariant.text ? 0 : DesignSystem.elevation2,
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
      shape: RoundedRectangleBorder(
        borderRadius: DesignSystem.borderRadiusMedium,
        side: variant == DSButtonVariant.outlined
            ? BorderSide(color: DesignSystem.primaryColor)
            : BorderSide.none,
      ),
    );
  }

  (Color, Color) _getColors() {
    switch (variant) {
      case DSButtonVariant.primary:
        return (DesignSystem.primaryColor, DesignSystem.textOnPrimary);
      case DSButtonVariant.secondary:
        return (DesignSystem.secondaryColor, DesignSystem.textOnPrimary);
      case DSButtonVariant.success:
        return (DesignSystem.success, DesignSystem.textOnPrimary);
      case DSButtonVariant.warning:
        return (DesignSystem.warning, DesignSystem.textOnPrimary);
      case DSButtonVariant.error:
        return (DesignSystem.error, DesignSystem.textOnPrimary);
      case DSButtonVariant.outlined:
        return (Colors.transparent, DesignSystem.primaryColor);
      case DSButtonVariant.text:
        return (Colors.transparent, DesignSystem.primaryColor);
    }
  }

  TextStyle _getTextStyle() {
    return DesignSystem.button.copyWith(
      fontSize: size == DSButtonSize.small
          ? DesignSystem.fontSize14
          : DesignSystem.fontSize16,
    );
  }

  double _getHeight() {
    switch (size) {
      case DSButtonSize.small:
        return DesignSystem.buttonHeightSmall;
      case DSButtonSize.medium:
        return DesignSystem.buttonHeightMedium;
      case DSButtonSize.large:
        return DesignSystem.buttonHeightLarge;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case DSButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingSmall,
          vertical: DesignSystem.paddingXSmall,
        );
      case DSButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingMedium,
          vertical: DesignSystem.paddingSmall,
        );
      case DSButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingLarge,
          vertical: DesignSystem.paddingMedium,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case DSButtonSize.small:
        return DesignSystem.iconSizeSmall;
      case DSButtonSize.medium:
        return DesignSystem.iconSizeMedium;
      case DSButtonSize.large:
        return DesignSystem.iconSizeMedium;
    }
  }
}

enum DSButtonVariant {
  primary,
  secondary,
  success,
  warning,
  error,
  outlined,
  text,
}

enum DSButtonSize {
  small,
  medium,
  large,
}
