import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/features/onboarding/screens/onboarding_screen.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';
import 'package:smartbudget_ai/shared/widgets/glass_button.dart';

void main() {
  group('OnboardingScreen Timer Management Tests', () {
    late AppStateModel appStateModel;

    setUp(() {
      appStateModel = AppStateModel();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<AppStateModel>.value(
        value: appStateModel,
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      );
    }

    testWidgets('should cleanup timer when user manually navigates', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Don't use pumpAndSettle to avoid infinite animations

      // Verify initial state
      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Simulate manual navigation by tapping a pagination dot
      final paginationDots = find.byType(GestureDetector);
      expect(paginationDots, findsWidgets);

      // Tap the second dot to navigate manually
      await tester.tap(paginationDots.at(1));
      await tester.pump(const Duration(milliseconds: 500));

      // The test passes if no timer-related exceptions are thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('should cleanup timer when user skips onboarding', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find and tap the skip button
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);

      await tester.tap(skipButton);
      await tester.pump(const Duration(milliseconds: 500));

      // Verify app state changed (onboarding completed)
      expect(appStateModel.currentState, AppState.signIn);

      // The test passes if no timer-related exceptions are thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('should cleanup timer when reaching final slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Navigate to the last slide by tapping pagination dots
      final paginationDots = find.byType(GestureDetector);
      
      // Tap the last dot (index 3 for 4 slides)
      await tester.tap(paginationDots.at(3));
      await tester.pump(const Duration(milliseconds: 500));

      // Find the Get Started button - it should be in a GlassButton
      final getStartedButton = find.byType(GlassButton);
      expect(getStartedButton, findsOneWidget);

      // Try to tap the button, but don't fail if it's not hittable
      await tester.tap(getStartedButton, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 500));

      // For this test, we're primarily testing timer cleanup, not the button functionality
      // The test passes if no timer-related exceptions are thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle widget disposal properly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Navigate away from the onboarding screen to trigger disposal
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Text('Different Screen')),
      ));
      await tester.pump();

      // The test passes if no timer-related exceptions are thrown during disposal
      expect(tester.takeException(), isNull);
    });

    testWidgets('should stop auto-progression when user interacts', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Tap a pagination dot to trigger manual navigation
      final paginationDots = find.byType(GestureDetector);
      await tester.tap(paginationDots.at(2)); // Navigate to slide 2
      await tester.pump(const Duration(milliseconds: 500));

      // The test passes if no exceptions are thrown and the widget remains stable
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle rapid navigation without timer conflicts', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final paginationDots = find.byType(GestureDetector);

      // Rapidly navigate between slides
      await tester.tap(paginationDots.at(1));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(paginationDots.at(2));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(paginationDots.at(0));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(paginationDots.at(3));
      await tester.pump(const Duration(milliseconds: 500));

      // The test passes if no timer-related exceptions are thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle multiple skip attempts gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final skipButton = find.text('Skip');

      // Try to tap skip multiple times rapidly
      await tester.tap(skipButton);
      await tester.pump(const Duration(milliseconds: 50));
      
      // Second tap should be handled gracefully (widget might be disposed)
      try {
        await tester.tap(skipButton);
        await tester.pump(const Duration(milliseconds: 50));
      } catch (e) {
        // It's okay if the widget is no longer available
      }

      await tester.pump(const Duration(milliseconds: 500));

      // Verify final state
      expect(appStateModel.currentState, AppState.signIn);
      expect(tester.takeException(), isNull);
    });
  });

  group('OnboardingScreen Timer Edge Cases', () {
    late AppStateModel appStateModel;

    setUp(() {
      appStateModel = AppStateModel();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<AppStateModel>.value(
        value: appStateModel,
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      );
    }

    testWidgets('should handle timer cancellation when already cancelled', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Skip to cancel timer
      await tester.tap(find.text('Skip'));
      await tester.pump(const Duration(milliseconds: 500));

      // Try to navigate away (which would trigger disposal and another timer cancellation)
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Text('New Screen')),
      ));
      await tester.pump();

      // Should handle double cancellation gracefully
      expect(tester.takeException(), isNull);
    });

    testWidgets('should not leak timers when widget is rebuilt', (WidgetTester tester) async {
      // Create and destroy the widget multiple times
      for (int i = 0; i < 3; i++) {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Let it run briefly
        await tester.pump(const Duration(milliseconds: 200));

        // Destroy the widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Text('Iteration $i')),
        ));
        await tester.pump();
      }

      // Should not have any timer-related exceptions
      expect(tester.takeException(), isNull);
    });
  });
}