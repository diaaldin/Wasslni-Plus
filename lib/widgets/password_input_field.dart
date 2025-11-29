import 'package:flutter/material.dart';
import 'package:turoudi/generated/l10n.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: const Icon(Icons.visibility_off),
        labelText: s.password,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
