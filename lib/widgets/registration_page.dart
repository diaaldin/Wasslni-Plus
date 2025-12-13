import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/services/security_service.dart';
import 'package:wasslni_plus/widgets/primary_buttom.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.merchant;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final security = SecurityService();
        await _authService.registerWithEmailPassword(
          email: security.sanitizeInput(_emailController.text),
          password: _passwordController.text
              .trim(), // Don't sanitize password characters
          name: security.sanitizeInput(_nameController.text),
          phoneNumber: security.sanitizeInput(_phoneController.text),
          role: _selectedRole,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).success)),
          );
          Navigator.pop(context); // Go back to login
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final security = SecurityService();

    return Scaffold(
      appBar: AppBar(title: Text(s.register)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: s.name,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (v) => v?.trim().isEmpty == true ? s.name : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: s.phone_number,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return s.validation_phone_invalid;
                  if (!security.isValidPhone(v))
                    return s.validation_phone_invalid;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: s.email,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return s.invalid_email;
                  if (!security.isValidEmail(v)) return s.invalid_email;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: s.password,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) =>
                    (v?.length ?? 0) < 6 ? s.enter_password : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                key: ValueKey(_selectedRole),
                initialValue: _selectedRole,
                decoration: InputDecoration(
                  labelText: s.role,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.work),
                ),
                items: [
                  DropdownMenuItem(
                      value: UserRole.merchant, child: Text(s.merchant)),
                  DropdownMenuItem(
                      value: UserRole.courier, child: Text(s.courier)),
                  DropdownMenuItem(
                      value: UserRole.customer, child: Text(s.customer)),
                ],
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: s.register,
                      onPressed: _register,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
