import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/onboarding/widgets/onboarding_pagination.dart';
import 'package:smartbudget_ai/core/constants/colors.dart';

void main() {
  group('OnboardingPagination Widget Tests', () {
    Widget createTestWidget({
      int currentIndex = 0,
      int totalSlides = 4,
      void Function(int)? onDotTapped,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: OnboardingPagination(
            currentIndex: currentIndex,
            totalSlides: totalSlides,
            onDotTapped: onDotTapped,
          ),
        ),
      );
    }

    testWidgets('should display correct number of pagination dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(totalSlides: 4));
      await tester.pumpAndSettle();

      // Find all GestureDetector widgets (one for each dot)
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsNWidgets(4));
    });

    testWidgets('should highlight active dot correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(currentIndex: 1, totalSlides: 4));
      await tester.pumpAndSettle();

      // Find all AnimatedContainer widgets (the dots)
      final animatedContainers = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(animatedContainers.length, 4);

      // Check that the active dot (index 1) has different width by checking the rendered size
      final activeDotFinder = find.byType(AnimatedContainer).at(1);
      final inactiveDotFinder = find.byType(AnimatedContainer).at(0);
      
      final activeDotSize = tester.getSize(activeDotFinder);
      final inactiveDotSize = tester.getSize(inactiveDotFinder);
      
      expect(activeDotSize.width, 36.0); // Active dot width (24 + 12 margin)
      expect(inactiveDotSize.width, 24.0); // Inactive dot width (12 + 12 margin)
    });

    testWidgets('should handle dot tap correctly', (WidgetTester tester) async {
      int tappedIndex = -1;
      
      await tester.pumpWidget(createTestWidget(
        totalSlides: 4,
        onDotTapped: (index) {
          tappedIndex = index;
        },
      ));
      await tester.pumpAndSettle();

      // Tap the third dot (index 2)
      final gestureDetectors = find.byType(GestureDetector);
      await tester.tap(gestureDetectors.at(2));
      await tester.pumpAndSettle();

      expect(tappedIndex, 2);
    });

    testWidgets('should handle null onDotTapped callback', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        totalSlides: 4,
        onDotTapped: null,
      ));
      await tester.pumpAndSettle();

      // Tap a dot - should not throw exception
      final gestureDetectors = find.byType(GestureDetector);
      await tester.tap(gestureDetectors.first);
      await tester.pumpAndSettle();

      // If no exception is thrown, the test passes
      expect(tester.takeException(), isNull);
    });

    testWidgets('should animate dot transitions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(currentIndex: 0, totalSlides: 4));
      await tester.pumpAndSettle();

      // Change active index
      await tester.pumpWidget(createTestWidget(currentIndex: 1, totalSlides: 4));
      await tester.pump(); // Don't settle to catch animation

      // Verify AnimatedContainer widgets exist (they handle the animation)
      expect(find.byType(AnimatedContainer), findsNWidgets(4));
    });

    testWidgets('should apply correct styling to active dot', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(currentIndex: 0, totalSlides: 4));
      await tester.pumpAndSettle();

      // Find the first AnimatedContainer (active dot) and check its rendered size
      final activeDotFinder = find.byType(AnimatedContainer).first;
      final activeDotSize = tester.getSize(activeDotFinder);
      
      expect(activeDotSize.width, 36.0); // 24 + 12 margin
      expect(activeDotSize.height, 12);
      
      // Check decoration
      final activeDotContainer = tester.widget<AnimatedContainer>(activeDotFinder);
      final decoration = activeDotContainer.decoration as BoxDecoration;
      expect(decoration.color, AppColors.glassButton);
      expect(decoration.border?.top.color, AppColors.glassBorderButton);
    });

    testWidgets('should apply correct styling to inactive dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(currentIndex: 0, totalSlides: 4));
      await tester.pumpAndSettle();

      // Find the second AnimatedContainer (inactive dot) and check its rendered size
      final inactiveDotFinder = find.byType(AnimatedContainer).at(1);
      final inactiveDotSize = tester.getSize(inactiveDotFinder);

      expect(inactiveDotSize.width, 24.0); // 12 + 12 margin
      expect(inactiveDotSize.height, 12);
      
      // Check decoration
      final inactiveDotContainer = tester.widget<AnimatedContainer>(inactiveDotFinder);
      final decoration = inactiveDotContainer.decoration as BoxDecoration;
      expect(decoration.color, AppColors.glassInput);
      expect(decoration.border?.top.color, AppColors.glassBorderInput);
    });

    testWidgets('should have proper border radius', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(totalSlides: 4));
      await tester.pumpAndSettle();

      // Check all dots have proper border radius
      final animatedContainers = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      
      for (final container in animatedContainers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(6));
      }
    });

    testWidgets('should display gradient for active dot', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(currentIndex: 0, totalSlides: 4));
      await tester.pumpAndSettle();

      // Find containers inside the active dot
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Look for container with gradient decoration (active dot inner container)
      bool foundGradientContainer = false;
      for (final container in containers) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration && decoration.gradient != null) {
          foundGradientContainer = true;
          break;
        }
      }
      
      expect(foundGradientContainer, isTrue);
    });

    testWidgets('should handle edge cases with single slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 1,
      ));
      await tester.pumpAndSettle();

      // Should display one dot
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('should handle edge cases with many slides', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 5,
        totalSlides: 10,
      ));
      await tester.pumpAndSettle();

      // Should display ten dots
      expect(find.byType(GestureDetector), findsNWidgets(10));
      expect(find.byType(AnimatedContainer), findsNWidgets(10));
    });

    testWidgets('should center align pagination dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(totalSlides: 4));
      await tester.pumpAndSettle();

      // Find the Row widget containing the dots
      final rowWidget = tester.widget<Row>(find.byType(Row));
      expect(rowWidget.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should apply proper spacing between dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(totalSlides: 4));
      await tester.pumpAndSettle();

      // Find all AnimatedContainer widgets
      final animatedContainers = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      
      // Check that each container has proper margin
      for (final container in animatedContainers) {
        expect(container.margin, isA<EdgeInsets>());
      }
    });
  });
}