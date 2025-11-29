import 'package:flutter/material.dart';
import 'package:turoudi/generated/l10n.dart'; // localization support
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/main.dart';
import 'package:turoudi/widgets/join_us.dart'; // your color/style definitions
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/generated/l10n.dart';
import 'package:turoudi/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return const Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
