import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wasslni_plus/widgets/network_aware_wrapper.dart';
import 'dart:async';

void main() {
  group('NetworkAwareWrapper Widget Tests', () {
    testWidgets('Should display child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkAwareWrapper(
            child: Scaffold(
              body: Center(child: Text('Test Content')),
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('Should show offline banner when showOfflineBanner is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkAwareWrapper(
            showOfflineBanner: true,
            child: Scaffold(
              body: Center(child: Text('Test Content')),
            ),
          ),
        ),
      );

      // Widget should render
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets(
        'Should not show offline banner when showOfflineBanner is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkAwareWrapper(
            showOfflineBanner: false,
            child: Scaffold(
              body: Center(child: Text('Test Content')),
            ),
          ),
        ),
      );

      // Should only show child content
      expect(find.text('Test Content'), findsOneWidget);
      // StreamBuilder should not be built
      expect(find.byType(StreamBuilder<ConnectivityResult>), findsNothing);
    });

    testWidgets('Child widget should always be rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkAwareWrapper(
            child: Scaffold(
              body: Center(child: Text('Always Visible')),
            ),
          ),
        ),
      );

      expect(find.text('Always Visible'), findsOneWidget);
    });

    testWidgets('Should use Column layout when offline banner is shown',
        (WidgetTester tester) async {
      final controller = StreamController<ConnectivityResult>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamBuilder<ConnectivityResult>(
              stream: controller.stream,
              builder: (context, snapshot) {
                final isOnline = snapshot.data != ConnectivityResult.none;

                if (isOnline) {
                  return const Center(child: Text('Online'));
                }

                return Column(
                  children: [
                    const Expanded(child: Center(child: Text('Offline'))),
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(8),
                      child: const Text('No Connection'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Add offline state
      controller.add(ConnectivityResult.none);
      await tester.pump();

      expect(find.text('Offline'), findsOneWidget);
      expect(find.text('No Connection'), findsOneWidget);
      expect(find.byType(Column), findsWidgets);

      controller.close();
    });

    testWidgets('Should handle widget rebuild', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkAwareWrapper(
            child: Scaffold(
              body: Center(child: Text('First Content')),
            ),
          ),
        ),
      );

      expect(find.text('First Content'), findsOneWidget);

      // Rebuild with different child
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkAwareWrapper(
            child: Scaffold(
              body: Center(child: Text('Second Content')),
            ),
          ),
        ),
      );

      expect(find.text('Second Content'), findsOneWidget);
      expect(find.text('First Content'), findsNothing);
    });

    testWidgets('Banner should use correct styling',
        (WidgetTester tester) async {
      final controller = StreamController<ConnectivityResult>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamBuilder<ConnectivityResult>(
              stream: controller.stream,
              builder: (context, snapshot) {
                if (snapshot.data != ConnectivityResult.none) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    Container(
                      width: double.infinity,
                      color: Colors.red[800],
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text(
                        'No Internet',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      controller.add(ConnectivityResult.none);
      await tester.pump();

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('No Internet'),
          matching: find.byType(Container),
        ),
      );

      expect(container.padding, const EdgeInsets.symmetric(vertical: 4));
      expect(container.color, Colors.red[800]);

      final text = tester.widget<Text>(find.text('No Internet'));
      expect(text.textAlign, TextAlign.center);
      expect(text.style?.color, Colors.white);
      expect(text.style?.fontSize, 12);

      controller.close();
    });
  });
}
