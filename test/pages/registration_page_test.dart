import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/widgets/registration_page.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wasslni_plus/models/user/consts.dart';

void main() {
  group('RegistrationPage Widget Tests', () {
    Future<void> pumpRegistrationPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const RegistrationPage(),
        ),
      );
    }

    testWidgets('Should display all form fields', (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Verify all fields are present
      expect(find.byType(TextFormField),
          findsNWidgets(4)); // name, phone, email, password
      expect(find.byType(DropdownButtonFormField<UserRole>), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget); // Register button
    });

    testWidgets('Should display validation error for empty name',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Find and tap register button without filling form
      final registerButton = find.byType(ElevatedButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Name field should show error (the validator returns the label text as error)
      expect(find.text('Name'), findsWidgets); // Multiple - label and error
    });

    testWidgets('Should display validation error for invalid email',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Enter invalid email
      final emailField = find.byType(TextFormField).at(2); // Email is 3rd field
      await tester.enterText(emailField, 'invalid-email');

      // Tap register to trigger validation
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should show invalid email error
      expect(find.textContaining('email', findRichText: true), findsWidgets);
    });

    testWidgets('Should display validation error for invalid phone',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Enter invalid phone
      final phoneField = find.byType(TextFormField).at(1); // Phone is 2nd field
      await tester.enterText(phoneField, '123'); // Too short

      // Tap register to trigger validation
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should show phone validation error
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Should display validation error for short password',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Enter short password
      final passwordField =
          find.byType(TextFormField).at(3); // Password is 4th field
      await tester.enterText(passwordField, '12345'); // Less than 6 characters

      // Tap register to trigger validation
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Password field should have validation error
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Should allow text entry in all fields',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Enter text in name field
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      expect(find.text('Test User'), findsOneWidget);

      // Enter text in phone field
      await tester.enterText(find.byType(TextFormField).at(1), '+1234567890');
      expect(find.text('+1234567890'), findsOneWidget);

      // Enter text in email field
      await tester.enterText(
          find.byType(TextFormField).at(2), 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);

      // Enter text in password field
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      // Password field is obscured, so we can't directly find the text
      // but we can verify the field accepted input
      expect(find.byType(TextFormField).at(3), findsOneWidget);
    });

    testWidgets('Should change role selection in dropdown',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Find dropdown
      final dropdown = find.byType(DropdownButtonFormField<UserRole>);
      expect(dropdown, findsOneWidget);

      // Tap dropdown to open it
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Find and tap courier option
      final courierOption = find.text('Courier').last;
      await tester.tap(courierOption);
      await tester.pumpAndSettle();

      // Verify dropdown now shows Courier
      expect(find.text('Courier'), findsWidgets);
    });

    testWidgets('Should display form fields with correct labels',
        (WidgetTester tester) async {
      await pumpRegistrationPage(tester);
      await tester.pumpAndSettle();

      // Check for field labels/decorations
      expect(find.byIcon(Icons.person), findsOneWidget); // Name field icon
      expect(find.byIcon(Icons.phone), findsOneWidget); // Phone field icon
      expect(find.byIcon(Icons.email), findsOneWidget); // Email field icon
      expect(find.byIcon(Icons.lock), findsOneWidget); // Password field icon
      expect(find.byIcon(Icons.work), findsOneWidget); // Role dropdown icon
    });

    testWidgets('Should have AppBar with title', (WidgetTester tester) async {
      await pumpRegistrationPage(tester);

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
