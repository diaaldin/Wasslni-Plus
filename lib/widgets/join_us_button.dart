import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/widgets/join_us.dart';

class JoinUsButton extends StatelessWidget {
  const JoinUsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const JoinUs(),
          ),
        );
      },
      child: Text(
        s.joinUs,
        style: const TextStyle(color: AppStyles.primaryColor),
      ),
    );
  }
}
