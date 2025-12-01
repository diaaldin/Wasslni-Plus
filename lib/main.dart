import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'firebase_options.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/flow/admin/admin_main.dart';
import 'package:wasslni_plus/flow/courier/courier_main.dart';
import 'package:wasslni_plus/flow/customer/customer_main.dart';
import 'package:wasslni_plus/flow/manager/manager_main.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/flow/merchant/merchant_main.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/provider/app_settings_providor.dart';
import 'package:wasslni_plus/widgets/NetworkAwareWrapper.dart';
import 'package:wasslni_plus/widgets/log_in.dart';
import 'package:wasslni_plus/widgets/session_timeout_manager.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsProvidor(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettingsProvidor>(context);

    return MaterialApp(
      title: 'Wasslni Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppStyles.primaryColor),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: appSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: appSettings.locale,
      home: const AuthenticationHandler(),
    );
  }
}

class AuthenticationHandler extends StatelessWidget {
  const AuthenticationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return const NetworkAwareWrapper(child: LoginPage());
        }

        // User is logged in, fetch user data to get role
        return FutureBuilder<UserModel?>(
          future: authService.getCurrentUserData(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            if (userSnapshot.hasError) {
              return Scaffold(
                  body: Center(child: Text('Error: ${userSnapshot.error}')));
            }

            final user = userSnapshot.data;
            if (user == null) {
              // User authenticated in Firebase but no Firestore profile.
              return const NetworkAwareWrapper(child: LoginPage());
            }

            // Wrap authenticated content with SessionTimeoutManager
            return SessionTimeoutManager(
              child: _getMainScreenBasedOnRole(user.role),
            );
          },
        );
      },
    );
  }

  Widget _getMainScreenBasedOnRole(UserRole userRole) {
    switch (userRole) {
      case UserRole.admin:
        return const NetworkAwareWrapper(child: AdminMainScreen());
      case UserRole.manager:
        return const NetworkAwareWrapper(child: ManagerMainScreen());
      case UserRole.merchant:
        return const NetworkAwareWrapper(child: MerchantMainScreen());
      case UserRole.courier:
        return const NetworkAwareWrapper(child: CourierMainScreen());
      case UserRole.customer:
        return const NetworkAwareWrapper(child: CustomerMainScreen());
      default:
        return const NetworkAwareWrapper(child: LoginPage());
    }
  }
}
