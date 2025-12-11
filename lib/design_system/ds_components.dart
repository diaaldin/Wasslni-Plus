import 'package:flutter/material.dart';
import 'package:wasslni_plus/design_system/design_tokens.dart';

/// Reusable Card Component with Design System tokens
class DSCard extends StatelessWidget {
  final Widget child;
  final DSCardVariant variant;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool elevated;

  const DSCard({
    super.key,
    required this.child,
    this.variant = DSCardVariant.default_,
    this.padding,
    this.onTap,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? const EdgeInsets.all(DesignSystem.paddingMedium);

    final decoration = BoxDecoration(
      color: _getBackgroundColor(),
      borderRadius: DesignSystem.borderRadiusMedium,
      border: variant == DSCardVariant.outlined
          ? Border.all(color: DesignSystem.neutral300)
          : null,
      boxShadow: elevated && variant != DSCardVariant.outlined
          ? DesignSystem.shadowSmall
          : null,
    );

    final cardContent = Container(
      padding: effectivePadding,
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: DesignSystem.borderRadiusMedium,
        child: cardContent,
      );
    }

    return cardContent;
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case DSCardVariant.default_:
        return DesignSystem.surfaceLight;
      case DSCardVariant.primary:
        return DesignSystem.primaryLight;
      case DSCardVariant.success:
        return DesignSystem.successLight;
      case DSCardVariant.warning:
        return DesignSystem.warningLight;
      case DSCardVariant.error:
        return DesignSystem.errorLight;
      case DSCardVariant.outlined:
        return DesignSystem.surfaceLight;
    }
  }
}

enum DSCardVariant {
  default_,
  primary,
  success,
  warning,
  error,
  outlined,
}

/// Reusable Badge Component
class DSBadge extends StatelessWidget {
  final String text;
  final DSBadgeVariant variant;
  final DSBadgeSize size;

  const DSBadge({
    super.key,
    required this.text,
    this.variant = DSBadgeVariant.neutral,
    this.size = DSBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(DesignSystem.radiusFull),
      ),
      child: Text(
        text,
        style: _getTextStyle(),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case DSBadgeSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingXSmall,
          vertical: DesignSystem.space1,
        );
      case DSBadgeSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingSmall,
          vertical: DesignSystem.paddingXSmall,
        );
      case DSBadgeSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingMedium,
          vertical: DesignSystem.paddingSmall,
        );
    }
  }

  TextStyle _getTextStyle() {
    final fontSize = size == DSBadgeSize.small
        ? DesignSystem.fontSize10
        : size == DSBadgeSize.medium
            ? DesignSystem.fontSize12
            : DesignSystem.fontSize14;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: DesignSystem.fontWeightMedium,
      color: _getTextColor(),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case DSBadgeVariant.primary:
        return DesignSystem.primaryColor;
      case DSBadgeVariant.success:
        return DesignSystem.success;
      case DSBadgeVariant.warning:
        return DesignSystem.warning;
      case DSBadgeVariant.error:
        return DesignSystem.error;
      case DSBadgeVariant.info:
        return DesignSystem.info;
      case DSBadgeVariant.neutral:
        return DesignSystem.neutral300;
    }
  }

  Color _getTextColor() {
    return variant == DSBadgeVariant.neutral
        ? DesignSystem.textPrimary
        : DesignSystem.textOnPrimary;
  }
}

enum DSBadgeVariant {
  primary,
  success,
  warning,
  error,
  info,
  neutral,
}

enum DSBadgeSize {
  small,
  medium,
  large,
}

/// Reusable Chip Component
class DSChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final bool selected;
  final VoidCallback? onTap;

  const DSChip({
    super.key,
    required this.label,
    this.icon,
    this.onDeleted,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar:
          icon != null ? Icon(icon, size: DesignSystem.iconSizeSmall) : null,
      onDeleted: onDeleted,
      selected: selected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: DesignSystem.neutral100,
      selectedColor: DesignSystem.primaryLight,
      labelStyle: TextStyle(
        color: selected ? DesignSystem.primaryDark : DesignSystem.textPrimary,
        fontWeight: selected
            ? DesignSystem.fontWeightMedium
            : DesignSystem.fontWeightRegular,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingSmall,
        vertical: DesignSystem.paddingXSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: DesignSystem.borderRadiusFull,
      ),
    );
  }
}
