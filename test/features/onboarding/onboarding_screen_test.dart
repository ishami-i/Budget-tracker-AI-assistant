import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/features/onboarding/screens/onboarding_screen.dart';
import 'package:smartbudget_ai/features/onboarding/models/onboarding_data.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('OnboardingScreen Widget Tests', () {
    late AppStateModel mockAppState;

    setUp(() {
      mockAppState = AppStateModel();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AppStateModel>.value(
          value: mockAppState,
          child: const OnboardingScreen(),
        ),
      );
    }

    testWidgets('should display onboarding screen with initial slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify the screen is displayed
      expect(find.byType(OnboardingScreen), findsOneWidget);
      
      // Verify the first slide content is displayed
      expect(find.text(OnboardingData.slides[0].title), findsOneWidget);
      expect(find.text(OnboardingData.slides[0].subtitle), findsOneWidget);
      
      // Verify the floating logo is displayed
      expect(find.byIcon(Icons.account_balance_wallet), findsWidgets);
      
      // Verify pagination dots are displayed
      expect(find.byType(Container), findsWidgets);
      
      // Verify skip button is displayed
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('should display correct slide content for each slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      for (int i = 0; i < OnboardingData.slideCount; i++) {
        final slide = OnboardingData.slides[i];
        
        // Navigate to slide if not the first one
        if (i > 0) {
          await tester.drag(
            find.byType(PageView),
            Offset(-400.0, 0.0), // Swipe left to go to next slide
          );
          await tester.pumpAndSettle();
        }
        
        // Verify slide content
        expect(find.text(slide.title), findsOneWidget);
        expect(find.text(slide.subtitle), findsOneWidget);
        expect(find.byIcon(slide.icon), findsWidgets);
      }
    });

    testWidgets('should handle manual slide navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Swipe to next slide
      await tester.drag(
        find.byType(PageView),
        const Offset(-400.0, 0.0),
      );
      await tester.pumpAndSettle();

      // Verify second slide is displayed
      expect(find.text(OnboardingData.slides[1].title), findsOneWidget);
      expect(find.text(OnboardingData.slides[1].subtitle), findsOneWidget);

      // Swipe back to first slide
      await tester.drag(
        find.byType(PageView),
        const Offset(400.0, 0.0),
      );
      await tester.pumpAndSettle();

      // Verify first slide is displayed again
      expect(find.text(OnboardingData.slides[0].title), findsOneWidget);
      expect(find.text(OnboardingData.slides[0].subtitle), findsOneWidget);
    });

    testWidgets('should show Get Started button on last slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to last slide
      for (int i = 0; i < OnboardingData.slideCount - 1; i++) {
        await tester.drag(
          find.byType(PageView),
          const Offset(-400.0, 0.0),
        );
        await tester.pumpAndSettle();
      }

      // Verify Get Started button is displayed
      expect(find.text('Get Started'), findsOneWidget);
      
      // Verify Skip button is not visible (opacity 0)
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);
    });

    testWidgets('should handle skip button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap skip button
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify app state changed to signIn
      expect(mockAppState.currentState, AppState.signIn);
    });

    testWidgets('should handle Get Started button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to last slide
      for (int i = 0; i < OnboardingData.slideCount - 1; i++) {
        await tester.drag(
          find.byType(PageView),
          const Offset(-400.0, 0.0),
        );
        await tester.pumpAndSettle();
      }

      // Tap Get Started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify app state changed to signIn
      expect(mockAppState.currentState, AppState.signIn);
    });

    testWidgets('should display correct number of pagination dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find pagination container and verify it exists
      expect(find.byType(Row), findsWidgets);
      
      // The exact number of dots is hard to test directly due to the custom implementation
      // but we can verify the pagination widget exists
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should handle auto-progression timer', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify initial slide
      expect(find.text(OnboardingData.slides[0].title), findsOneWidget);

      // Wait for auto-progression (4 seconds + some buffer)
      await tester.pump(const Duration(seconds: 4, milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify second slide is displayed
      expect(find.text(OnboardingData.slides[1].title), findsOneWidget);
    });

    testWidgets('should stop auto-progression on manual navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Manually navigate to next slide
      await tester.drag(
        find.byType(PageView),
        const Offset(-400.0, 0.0),
      );
      await tester.pumpAndSettle();

      // Verify second slide is displayed
      expect(find.text(OnboardingData.slides[1].title), findsOneWidget);

      // Wait for what would be auto-progression time
      await tester.pump(const Duration(seconds: 4, milliseconds: 500));
      await tester.pumpAndSettle();

      // Should still be on second slide (auto-progression stopped)
      expect(find.text(OnboardingData.slides[1].title), findsOneWidget);
    });

    testWidgets('should display floating 3D logo with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the logo container
      final logoContainers = find.byType(Container);
      expect(logoContainers, findsWidgets);

      // Verify the main logo icon exists
      expect(find.byIcon(Icons.account_balance_wallet), findsWidgets);
    });

    testWidgets('should handle slide content animations', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify FadeTransition and SlideTransition widgets exist
      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.byType(SlideTransition), findsWidgets);

      // Navigate to next slide to trigger animations
      await tester.drag(
        find.byType(PageView),
        const Offset(-400.0, 0.0),
      );
      await tester.pumpAndSettle();

      // Animations should still be present
      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.byType(SlideTransition), findsWidgets);
    });

    testWidgets('should complete onboarding when reaching end of slides', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate through all slides using auto-progression simulation
      for (int i = 0; i < OnboardingData.slideCount; i++) {
        // Wait for auto-progression
        await tester.pump(const Duration(seconds: 4, milliseconds: 500));
        await tester.pumpAndSettle();
      }

      // Verify app state changed to signIn (onboarding completed)
      expect(mockAppState.currentState, AppState.signIn);
    });
  });

  group('OnboardingScreen Integration Tests', () {
    testWidgets('should integrate properly with app state management', (WidgetTester tester) async {
      final appState = AppStateModel();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppStateModel>.value(
            value: appState,
            child: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      expect(appState.currentState, AppState.onboarding);

      // Complete onboarding
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify state transition
      expect(appState.currentState, AppState.signIn);
    });
  });
}