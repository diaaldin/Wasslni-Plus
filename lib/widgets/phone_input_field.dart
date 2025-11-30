import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone),
          labelText: s.phone_number,
          counterText: "0/10",
          border: const OutlineInputBorder(),
        ),
        maxLength: 10,
        keyboardType: TextInputType.phone,
        validator: (value) {
          final s = S.of(context);
          if (value == null || value.isEmpty) {
            return s.validation_phone_required;
          } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            return s.validation_phone_invalid;
          }
          return null;
        });
  }
}
