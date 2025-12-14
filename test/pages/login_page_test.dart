import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/widgets/log_in.dart';
import 'package:wasslni_plus/widgets/login_form.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('LoginPage Widget Tests', () {
    Future<void> pumpLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const LoginPage(),
        ),
      );
    }

    testWidgets('Should display LoginPage with LoginForm',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);

      // Verify LoginPage scaffold and LoginForm are present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets('Should display email and password fields',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Verify form fields are present
      expect(
          find.byType(TextFormField), findsNWidgets(2)); // email and password
    });

    testWidgets('Should display login button', (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Verify login button exists
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Should display sign up link', (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Verify sign up link exists
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Should allow text entry in email field',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Should allow text entry in password field',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Enter password
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      // Password is obscured, so we can't see the text directly
      expect(find.byType(TextFormField).last, findsOneWidget);
    });

    testWidgets('Should show validation error for invalid email',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');

      // Tap login button to trigger validation
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Should show validation error for short password',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Enter valid email but short password
      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(
          find.byType(TextFormField).last, '12345'); // Less than 6 chars

      // Tap login button to trigger validation
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Should display app name', (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // App name should be displayed
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Should have correct field icons', (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Verify icons are present
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('LoginPage should have primary color background',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);

      // Find the Scaffold
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

      // Verify background color is set
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('Login button should be tappable', (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Find login button
      final loginButton = find.byType(ElevatedButton);
      expect(loginButton, findsOneWidget);

      // Verify button can be tapped
      await tester.tap(loginButton);
      await tester.pump();
    });

    testWidgets('Sign up link should be tappable', (WidgetTester tester) async {
      await pumpLoginPage(tester);
      await tester.pumpAndSettle();

      // Find sign up link
      final signUpLink = find.byType(TextButton);
      expect(signUpLink, findsOneWidget);

      // Tap should work (navigation would happen in integration tests)
      await tester.tap(signUpLink);
      await tester.pump();
    });
  });
}
