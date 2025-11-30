import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/widgets/join_us_button.dart';
import 'package:wasslni_plus/widgets/login_button.dart';
import 'package:wasslni_plus/widgets/password_input_field.dart';
import 'package:wasslni_plus/widgets/phone_input_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              s.app_name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppStyles.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const PhoneInputField(),
            const SizedBox(height: 16),
            const PasswordInputField(),
            const SizedBox(height: 24),
            LoginButton(formKey: _formKey),
            const SizedBox(height: 12),
            const JoinUsButton(),
          ],
        ),
      ),
    );
  }
}
