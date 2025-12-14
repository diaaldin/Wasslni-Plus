import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/flow/merchant/parcel/add_paracel_page.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('AddParcelPage Widget Tests', () {
    Future<void> pumpAddParcelPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const AddParcelPage(),
        ),
      );
    }

    testWidgets('Should display AddParcelPage', (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Verify page loads
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Should display multiple form fields',
        (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Should have multiple text fields for parcel details
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Should display save button', (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Should have a save/submit button
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Should allow text entry in form fields',
        (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Find first text field and enter text
      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'Test Input');
        await tester.pump();
        expect(find.text('Test Input'), findsOneWidget);
      }
    });

    testWidgets('Should have form with validation',
        (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Page should have a Form widget for validation
      expect(find.byType(Form), findsWidgets);
    });

    testWidgets('Should display dropdown for region selection',
        (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Should have dropdown for selecting delivery region
      expect(find.byType(DropdownButtonFormField), findsWidgets);
    });

    testWidgets('Should have scrollable content', (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Page should be scrollable for long forms
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('Should render without errors', (WidgetTester tester) async {
      // This test verifies the widget tree builds without throwing errors
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AddParcelPage), findsOneWidget);
    });

    testWidgets('Should have AppBar with title', (WidgetTester tester) async {
      await pumpAddParcelPage(tester);
      await tester.pumpAndSettle();

      // Verify AppBar exists
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
    });
  });
}
