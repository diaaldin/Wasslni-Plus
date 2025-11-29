import 'package:flutter/material.dart';
import 'package:turoudi/generated/l10n.dart';

class PolicyCheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PolicyCheckboxRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(val ?? false),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              // Navigate to PrivacyPolicy if needed
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: s.acceptPolicyStart),
                  TextSpan(
                    text: s.dataPolicy,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
