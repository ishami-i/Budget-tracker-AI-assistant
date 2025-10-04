import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/features/onboarding/screens/onboarding_screen.dart';
import 'package:smartbudget_ai/features/onboarding/models/onboarding_data.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('Onboarding Integration Tests', () {
    late AppStateModel appState;

    setUp(() {
      appState = AppStateModel();
    });

    Widget createTestApp() {
      return MaterialApp(
        home: ChangeNotifierProvider<AppStateModel>.value(
          value: appState,
          child: const OnboardingScreen(),
        ),
      );
    }

    testWidgets('should create onboarding screen without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Verify the screen is created
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('should display first slide content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Verify first slide content is displayed
      final firstSlide = OnboardingData.slides[0];
      expect(find.text(firstSlide.title), findsOneWidget);
      expect(find.text(firstSlide.subtitle), findsOneWidget);
    });

    testWidgets('should handle skip button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Find and tap skip button
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);
      
      await tester.tap(skipButton);
      await tester.pump();

      // Verify app state changed
      expect(appState.currentState, AppState.signIn);
    });

    testWidgets('should display pagination dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Verify pagination exists (look for GestureDetector which wraps dots)
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should display logo with proper icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Verify logo icon is displayed
      expect(find.byIcon(Icons.account_balance_wallet), findsWidgets);
    });

    testWidgets('should handle manual slide navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Find PageView and swipe
      final pageView = find.byType(PageView);
      expect(pageView, findsOneWidget);

      // Swipe to next slide
      await tester.drag(pageView, const Offset(-400.0, 0.0));
      await tester.pump();

      // Verify second slide content appears
      final secondSlide = OnboardingData.slides[1];
      expect(find.text(secondSlide.title), findsOneWidget);
    });

    testWidgets('should show Get Started on last slide', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final pageView = find.byType(PageView);
      
      // Navigate to last slide
      for (int i = 0; i < OnboardingData.slideCount - 1; i++) {
        await tester.drag(pageView, const Offset(-400.0, 0.0));
        await tester.pump();
      }

      // Verify Get Started button exists
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('should handle Get Started button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final pageView = find.byType(PageView);
      
      // Navigate to last slide
      for (int i = 0; i < OnboardingData.slideCount - 1; i++) {
        await tester.drag(pageView, const Offset(-400.0, 0.0));
        await tester.pump();
      }

      // Tap Get Started button
      await tester.tap(find.text('Get Started'));
      await tester.pump();

      // Verify app state changed
      expect(appState.currentState, AppState.signIn);
    });
  });
}