import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/widgets/fields/editable_field.dart';

void main() {
  group('EditableField Widget Tests', () {
    testWidgets('renders label and initial text', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Initial Value');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EditableField(
            label: 'Test Label',
            controller: controller,
            isEditMode: true,
          ),
        ),
      ));

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Initial Value'), findsOneWidget);
    });

    testWidgets('is disabled when isEditMode is false',
        (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Read Only');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EditableField(
            label: 'Test Label',
            controller: controller,
            isEditMode: false,
          ),
        ),
      ));

      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, false);
    });

    testWidgets('updates controller when typed into',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EditableField(
            label: 'Input',
            controller: controller,
            isEditMode: true,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'New Text');
      expect(controller.text, 'New Text');
    });

    testWidgets('applies validator', (WidgetTester tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: EditableField(
              label: 'Input',
              controller: controller,
              isEditMode: true,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
          ),
        ),
      ));

      // Trigger validation
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Valid');
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsNothing);
    });
  });
}
