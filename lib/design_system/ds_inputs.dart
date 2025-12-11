import 'package:flutter/material.dart';
import 'package:wasslni_plus/design_system/design_tokens.dart';

/// Reusable Input Field Component with Design System tokens
class DSTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final DSInputSize size;

  const DSTextField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.size = DSInputSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: DesignSystem.bodySmall.copyWith(
              fontWeight: DesignSystem.fontWeightMedium,
            ),
          ),
          const SizedBox(height: DesignSystem.space2),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          style: _getTextStyle(),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixIconTap,
                  )
                : null,
            filled: true,
            fillColor:
                enabled ? DesignSystem.surfaceLight : DesignSystem.neutral100,
            border: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide: BorderSide(color: DesignSystem.neutral300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide: BorderSide(color: DesignSystem.neutral300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide:
                  BorderSide(color: DesignSystem.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide: BorderSide(color: DesignSystem.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide: BorderSide(color: DesignSystem.error, width: 2),
            ),
            contentPadding: _getContentPadding(),
          ),
        ),
      ],
    );
  }

  TextStyle _getTextStyle() {
    return DesignSystem.bodyMedium.copyWith(
      fontSize: size == DSInputSize.small
          ? DesignSystem.fontSize14
          : DesignSystem.fontSize16,
    );
  }

  EdgeInsets _getContentPadding() {
    switch (size) {
      case DSInputSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingSmall,
          vertical: DesignSystem.paddingXSmall,
        );
      case DSInputSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingMedium,
          vertical: DesignSystem.paddingSmall,
        );
      case DSInputSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.paddingLarge,
          vertical: DesignSystem.paddingMedium,
        );
    }
  }
}

enum DSInputSize {
  small,
  medium,
  large,
}

/// Reusable Dropdown Component
class DSDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<DSDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? errorText;

  const DSDropdown({
    super.key,
    this.label,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: DesignSystem.bodySmall.copyWith(
              fontWeight: DesignSystem.fontWeightMedium,
            ),
          ),
          const SizedBox(height: DesignSystem.space2),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item.value,
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(item.icon, size: DesignSystem.iconSizeMedium),
                          const SizedBox(width: DesignSystem.space2),
                        ],
                        Text(item.label),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            filled: true,
            fillColor: DesignSystem.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide: BorderSide(color: DesignSystem.neutral300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide: BorderSide(color: DesignSystem.neutral300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: DesignSystem.borderRadiusMedium,
              borderSide:
                  BorderSide(color: DesignSystem.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.paddingMedium,
              vertical: DesignSystem.paddingSmall,
            ),
          ),
        ),
      ],
    );
  }
}

class DSDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  DSDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Reusable Checkbox Component
class DSCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const DSCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: DesignSystem.borderRadiusSmall,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: DesignSystem.paddingXSmall),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: DesignSystem.primaryColor,
            ),
            const SizedBox(width: DesignSystem.space2),
            Expanded(
              child: Text(
                label,
                style: DesignSystem.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Radio Button Component
class DSRadio<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const DSRadio({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: DesignSystem.borderRadiusSmall,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: DesignSystem.paddingXSmall),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: DesignSystem.primaryColor,
            ),
            const SizedBox(width: DesignSystem.space2),
            Expanded(
              child: Text(
                label,
                style: DesignSystem.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
