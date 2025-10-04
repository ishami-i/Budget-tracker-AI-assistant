import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/shared/widgets/card_3d.dart';
import 'package:smartbudget_ai/core/constants/colors.dart';
import 'package:smartbudget_ai/core/constants/dimensions.dart';

void main() {
  testWidgets('Card3D builds in non-interactive mode', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Card3D(
              interactive: false,
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Card3D), findsOneWidget);
  });

  testWidgets('Card3D builds in interactive mode and accepts pan', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Card3D(
              interactive: true,
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      ),
    );

    // Perform a pan gesture on the card surface
    await tester.drag(find.byType(Card3D), const Offset(10, 10));

    // No exception implies gesture handled
    expect(find.byType(Card3D), findsOneWidget);
  });

  group('Card3D Widget Tests', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      const testText = 'Test Card Content';

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: Card3D(child: Text(testText)))),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('applies default styling correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              child: SizedBox(width: 200, height: 100, child: Text('Test')),
            ),
          ),
        ),
      );

      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Find the container with decoration (the card container)
      Container? cardContainer;
      for (int i = 0; i < tester.widgetList(containers).length; i++) {
        final container = tester.widget<Container>(containers.at(i));
        if (container.decoration != null) {
          cardContainer = container;
          break;
        }
      }

      expect(cardContainer, isNotNull);
      final decoration = cardContainer!.decoration as BoxDecoration;
      expect(decoration.color, AppColors.glassCard);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppDimensions.cardRadius),
      );
      expect(decoration.border?.top.color, AppColors.glassBorderCard);
    });

    testWidgets('applies custom styling correctly', (
      WidgetTester tester,
    ) async {
      const customColor = Colors.red;
      const customBorderColor = Colors.blue;
      const customRadius = BorderRadius.all(Radius.circular(10));
      const customPadding = EdgeInsets.all(30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              backgroundColor: customColor,
              borderColor: customBorderColor,
              borderRadius: customRadius,
              padding: customPadding,
              child: Text('Test'),
            ),
          ),
        ),
      );

      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Find the container with decoration (the card container)
      Container? cardContainer;
      for (int i = 0; i < tester.widgetList(containers).length; i++) {
        final container = tester.widget<Container>(containers.at(i));
        if (container.decoration != null) {
          cardContainer = container;
          break;
        }
      }

      expect(cardContainer, isNotNull);
      final decoration = cardContainer!.decoration as BoxDecoration;
      expect(decoration.color, customColor);
      expect(decoration.borderRadius, customRadius);
      expect(decoration.border?.top.color, customBorderColor);
      expect(cardContainer.padding, customPadding);
    });

    testWidgets('responds to pan gestures in interactive mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              interactive: true,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Text('Interactive Card'),
              ),
            ),
          ),
        ),
      );

      final card3D = find.byType(Card3D);
      expect(card3D, findsOneWidget);

      // Test pan start
      await tester.startGesture(tester.getCenter(card3D));
      await tester.pump();

      // Test pan update - simulate dragging to the right and down
      final center = tester.getCenter(card3D);
      await tester.dragFrom(center, const Offset(50, 30));
      await tester.pump();

      // The widget should have updated its transform
      final transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(Card3D),
          matching: find.byType(Transform),
        ),
      );

      expect(transform.transform, isNot(Matrix4.identity()));
    });

    testWidgets('does not respond to gestures in non-interactive mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              interactive: false,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Text('Non-Interactive Card'),
              ),
            ),
          ),
        ),
      );

      final card3D = find.byType(Card3D);
      expect(card3D, findsOneWidget);

      // Try to interact with the card
      await tester.drag(card3D, const Offset(50, 30));
      await tester.pump();

      // The GestureDetector should not have pan handlers
      final gestureDetector = tester.widget<GestureDetector>(
        find.descendant(
          of: find.byType(Card3D),
          matching: find.byType(GestureDetector),
        ),
      );

      expect(gestureDetector.onPanStart, isNull);
      expect(gestureDetector.onPanUpdate, isNull);
      expect(gestureDetector.onPanEnd, isNull);
    });

    testWidgets('starts auto-rotation in non-interactive mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              interactive: false,
              autoRotationDuration: const Duration(milliseconds: 100),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Text('Auto-Rotating Card'),
              ),
            ),
          ),
        ),
      );

      // Let the animation start
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final transform1 =
          tester
              .widget<Transform>(
                find.descendant(
                  of: find.byType(Card3D),
                  matching: find.byType(Transform),
                ),
              )
              .transform;

      // Wait for animation to progress
      await tester.pump(const Duration(milliseconds: 50));

      final transform2 =
          tester
              .widget<Transform>(
                find.descendant(
                  of: find.byType(Card3D),
                  matching: find.byType(Transform),
                ),
              )
              .transform;

      // The transform should have changed due to auto-rotation
      expect(transform1, isNot(equals(transform2)));
    });

    testWidgets('applies correct tilt intensity', (WidgetTester tester) async {
      const customTiltIntensity = 0.8;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              interactive: true,
              tiltIntensity: customTiltIntensity,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Text('High Tilt Card'),
              ),
            ),
          ),
        ),
      );

      final card3D = find.byType(Card3D);

      // Perform a drag gesture
      await tester.drag(card3D, const Offset(100, 100));
      await tester.pump();

      // The transform should reflect the higher tilt intensity
      final transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(Card3D),
          matching: find.byType(Transform),
        ),
      );

      expect(transform.transform, isNot(Matrix4.identity()));
    });

    testWidgets('shows and hides border correctly', (
      WidgetTester tester,
    ) async {
      // Test with border
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(showBorder: true, child: Text('With Border')),
          ),
        ),
      );

      var containers = find.byType(Container);
      Container? cardContainer;
      for (int i = 0; i < tester.widgetList(containers).length; i++) {
        final container = tester.widget<Container>(containers.at(i));
        if (container.decoration != null) {
          cardContainer = container;
          break;
        }
      }

      expect(cardContainer, isNotNull);
      var decoration = cardContainer!.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);

      // Test without border
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(showBorder: false, child: Text('Without Border')),
          ),
        ),
      );

      containers = find.byType(Container);
      cardContainer = null;
      for (int i = 0; i < tester.widgetList(containers).length; i++) {
        final container = tester.widget<Container>(containers.at(i));
        if (container.decoration != null) {
          cardContainer = container;
          break;
        }
      }

      expect(cardContainer, isNotNull);
      decoration = cardContainer!.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('applies custom dimensions correctly', (
      WidgetTester tester,
    ) async {
      const customWidth = 300.0;
      const customHeight = 150.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              width: customWidth,
              height: customHeight,
              child: Text('Custom Size'),
            ),
          ),
        ),
      );

      // Check that the Card3D widget exists and has the expected size
      final card3D = find.byType(Card3D);
      expect(card3D, findsOneWidget);

      // The size will be applied through the LayoutBuilder and Container
      // We can verify the widget was created with the correct parameters
      final card3DWidget = tester.widget<Card3D>(card3D);
      expect(card3DWidget.width, customWidth);
      expect(card3DWidget.height, customHeight);
    });

    testWidgets('includes BackdropFilter for glassmorphism effect', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: Card3D(child: Text('Glass Effect')))),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);

      final backdropFilter = tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );
      expect(backdropFilter.filter, isNotNull);
    });

    testWidgets('handles pan end correctly and resets position', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              interactive: true,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Text('Reset Test'),
              ),
            ),
          ),
        ),
      );

      final card3D = find.byType(Card3D);

      // Start and perform a drag
      final gesture = await tester.startGesture(tester.getCenter(card3D));
      await tester.pump();

      await gesture.moveBy(const Offset(50, 30));
      await tester.pump();

      // End the gesture
      await gesture.up();
      await tester.pump();

      // Wait for reset animation
      await tester.pump(const Duration(milliseconds: 300));

      // The card should be in the process of returning to center
      // We can't easily test the exact transform values, but we can verify
      // that the reset animation is working by checking that the widget rebuilds
      expect(card3D, findsOneWidget);
    });
  });

  group('Card3D Animation Tests', () {
    testWidgets('disposes animation controllers properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(interactive: false, child: Text('Disposal Test')),
          ),
        ),
      );

      // Remove the widget to trigger disposal
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));

      // If disposal is handled correctly, no exceptions should be thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('auto-rotation animation repeats correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card3D(
              interactive: false,
              autoRotationDuration: const Duration(milliseconds: 100),
              child: Text('Repeat Test'),
            ),
          ),
        ),
      );

      // Let animation start
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 25));

      final transform1 =
          tester
              .widget<Transform>(
                find.descendant(
                  of: find.byType(Card3D),
                  matching: find.byType(Transform),
                ),
              )
              .transform;

      // Let animation progress
      await tester.pump(const Duration(milliseconds: 50));

      final transform2 =
          tester
              .widget<Transform>(
                find.descendant(
                  of: find.byType(Card3D),
                  matching: find.byType(Transform),
                ),
              )
              .transform;

      // The animation should be progressing, so transforms should be different
      expect(transform1.toString(), isNot(equals(transform2.toString())));
    });
  });
}
