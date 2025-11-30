import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/widgets/phone_input_field.dart';

class JoinUsForm extends StatelessWidget {
  const JoinUsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: s.name,
            prefixIcon: const Icon(Icons.person),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        const PhoneInputField(),
        const SizedBox(height: 12),
        TextField(
          maxLength: 20,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: s.message,
            prefixIcon: const Icon(Icons.message),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
