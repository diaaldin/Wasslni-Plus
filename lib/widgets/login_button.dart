import 'package:flutter/material.dart';
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/generated/l10n.dart';
import 'package:turoudi/main.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const LoginButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthenticationHandler(),
              ),
            );
          }
        },
        child: Text(
          s.login,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
