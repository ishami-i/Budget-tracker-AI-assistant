import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/onboarding/widgets/onboarding_controls.dart';
import 'package:smartbudget_ai/shared/widgets/glass_button.dart';

void main() {
  group('OnboardingControls Widget Tests', () {
    Widget createTestWidget({
      int currentIndex = 0,
      int totalSlides = 4,
      VoidCallback? onSkip,
      VoidCallback? onGetStarted,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: OnboardingControls(
            currentIndex: currentIndex,
            totalSlides: totalSlides,
            onSkip: onSkip,
            onGetStarted: onGetStarted,
          ),
        ),
      );
    }

    testWidgets('should display skip button on non-last slides', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Skip button should be visible
      expect(find.text('Skip'), findsOneWidget);
      
      // Get Started button should not be visible (opacity 0)
      expect(find.text('Get Started'), findsOneWidget);
      
      // Check opacity of skip button (should be 1.0)
      final skipOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Skip'),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(skipOpacity.opacity, 1.0);
    });

    testWidgets('should display Get Started button on last slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 3, // Last slide (0-indexed)
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Both buttons should exist but with different opacities
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      
      // Check opacity of Get Started button (should be 1.0)
      final getStartedOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Get Started'),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(getStartedOpacity.opacity, 1.0);
      
      // Check opacity of Skip button (should be 0.0)
      final skipOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Skip'),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(skipOpacity.opacity, 0.0);
    });

    testWidgets('should handle skip button tap', (WidgetTester tester) async {
      bool skipTapped = false;
      
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
        onSkip: () {
          skipTapped = true;
        },
      ));
      await tester.pumpAndSettle();

      // Tap skip button
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(skipTapped, isTrue);
    });

    testWidgets('should handle Get Started button tap', (WidgetTester tester) async {
      bool getStartedTapped = false;
      
      await tester.pumpWidget(createTestWidget(
        currentIndex: 3, // Last slide
        totalSlides: 4,
        onGetStarted: () {
          getStartedTapped = true;
        },
      ));
      await tester.pumpAndSettle();

      // Tap Get Started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(getStartedTapped, isTrue);
    });

    testWidgets('should not handle skip tap on last slide', (WidgetTester tester) async {
      bool skipTapped = false;
      
      await tester.pumpWidget(createTestWidget(
        currentIndex: 3, // Last slide
        totalSlides: 4,
        onSkip: () {
          skipTapped = true;
        },
      ));
      await tester.pumpAndSettle();

      // Try to tap skip button (should be disabled/invisible)
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(skipTapped, isFalse);
    });

    testWidgets('should not handle Get Started tap on non-last slide', (WidgetTester tester) async {
      bool getStartedTapped = false;
      
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0, // Not last slide
        totalSlides: 4,
        onGetStarted: () {
          getStartedTapped = true;
        },
      ));
      await tester.pumpAndSettle();

      // Try to tap Get Started button (should be disabled/invisible)
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(getStartedTapped, isFalse);
    });

    testWidgets('should handle null callbacks gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
        onSkip: null,
        onGetStarted: null,
      ));
      await tester.pumpAndSettle();

      // Tap skip button - should not throw exception
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('should animate opacity transitions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Change to last slide
      await tester.pumpWidget(createTestWidget(
        currentIndex: 3,
        totalSlides: 4,
      ));
      await tester.pump(); // Don't settle to catch animation

      // Verify AnimatedOpacity widgets exist
      expect(find.byType(AnimatedOpacity), findsNWidgets(2));
    });

    testWidgets('should use GlassButton for Get Started button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 3, // Last slide
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Verify GlassButton is used
      expect(find.byType(GlassButton), findsOneWidget);
      
      // Verify it has the correct text
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('should display arrow icon in Get Started button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 3, // Last slide
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Verify arrow icon is present
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('should apply proper styling to skip button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Find the skip button container
      final skipContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('Skip'),
          matching: find.byType(Container),
        ).first,
      );

      // Verify decoration
      expect(skipContainer.decoration, isA<BoxDecoration>());
      final decoration = skipContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
      expect(decoration.border, isA<Border>());
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Verify main container structure
      expect(find.byType(Container), findsWidgets);
      
      // Verify Row for layout (find the main layout Row)
      final rows = find.byType(Row);
      expect(rows, findsWidgets);
      
      // Check the first Row alignment (main layout Row)
      final rowWidget = tester.widget<Row>(rows.first);
      expect(rowWidget.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('should handle single slide scenario', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 1, // Only one slide
      ));
      await tester.pumpAndSettle();

      // Should show Get Started button (since it's the last slide)
      final getStartedOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Get Started'),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(getStartedOpacity.opacity, 1.0);
      
      // Skip button should be hidden
      final skipOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Skip'),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(skipOpacity.opacity, 0.0);
    });

    testWidgets('should apply proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentIndex: 0,
        totalSlides: 4,
      ));
      await tester.pumpAndSettle();

      // Find the main container
      final mainContainer = tester.widget<Container>(find.byType(Container).first);
      expect(mainContainer.padding, isA<EdgeInsets>());
    });
  });
}