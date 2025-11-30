import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart'; // localization support
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/main.dart';
import 'package:wasslni_plus/widgets/join_us.dart'; // your color/style definitions
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/widgets/login_form.dart';

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
