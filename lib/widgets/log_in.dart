import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';

import 'package:wasslni_plus/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
