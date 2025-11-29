import 'package:flutter/material.dart';
import 'package:turoudi/generated/l10n.dart';

class JoinUsDescriptionCard extends StatelessWidget {
  const JoinUsDescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          s.joinUsDescription,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
