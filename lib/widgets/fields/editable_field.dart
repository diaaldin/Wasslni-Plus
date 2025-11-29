import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turoudi/app_styles.dart';

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditMode;
  final bool forceLTR;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;

  const EditableField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditMode,
    this.forceLTR = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: isEditMode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
        cursorColor: AppStyles.primaryColor,
        textDirection:
            forceLTR ? TextDirection.ltr : Directionality.of(context),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.labelLarge?.color,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppStyles.primaryColor,
            ),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
