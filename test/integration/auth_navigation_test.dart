import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/app/app.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('Auth Navigation Integration Tests', () {
    testWidgets('can navigate between sign-in and sign-up screens', (WidgetTester tester) async {
      // Create app with initial state set to sign-in
      final appStateModel = AppStateModel();
      appStateModel.navigateToState(AppState.signIn);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SmartBudgetApp(),
        ),
      );
      await tester.pump(); // Allow the widget to build

      // Verify we're on sign-in screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue to SmartBudget AI'), findsOneWidget);

      // Navigate to sign-up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify we're on sign-up screen
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join SmartBudget AI to start managing your finances'), findsOneWidget);

      // Navigate back to sign-in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify we're back on sign-in screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue to SmartBudget AI'), findsOneWidget);
    });

    testWidgets('social sign-in placeholders work on both screens', (WidgetTester tester) async {
      final appStateModel = AppStateModel();
      appStateModel.navigateToState(AppState.signIn);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SmartBudgetApp(),
        ),
      );

      // Test Google sign-in on sign-in screen
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();
      expect(find.text('Coming Soon'), findsOneWidget);
      expect(find.text('Google sign-in will be available in a future update.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Test Apple sign-in on sign-in screen
      await tester.tap(find.text('Continue with Apple'));
      await tester.pumpAndSettle();
      expect(find.text('Coming Soon'), findsOneWidget);
      expect(find.text('Apple sign-in will be available in a future update.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Navigate to sign-up screen
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Test Google sign-in on sign-up screen
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();
      expect(find.text('Coming Soon'), findsOneWidget);
      expect(find.text('Google sign-in will be available in a future update.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Test Apple sign-in on sign-up screen
      await tester.tap(find.text('Continue with Apple'));
      await tester.pumpAndSettle();
      expect(find.text('Coming Soon'), findsOneWidget);
      expect(find.text('Apple sign-in will be available in a future update.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });

    testWidgets('forgot password placeholder works on sign-in screen', (WidgetTester tester) async {
      final appStateModel = AppStateModel();
      appStateModel.navigateToState(AppState.signIn);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SmartBudgetApp(),
        ),
      );

      // Test forgot password functionality
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();
      
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Password reset functionality will be available in a future update.'), findsOneWidget);
      
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Verify we're still on sign-in screen
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('app state transitions are valid', (WidgetTester tester) async {
      final appStateModel = AppStateModel();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SmartBudgetApp(),
        ),
      );

      // Start from onboarding (default state)
      expect(appStateModel.currentState, AppState.onboarding);

      // Navigate to sign-in
      appStateModel.navigateToState(AppState.signIn);
      await tester.pumpAndSettle();
      expect(appStateModel.currentState, AppState.signIn);

      // Navigate to sign-up from sign-in
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(appStateModel.currentState, AppState.signUp);

      // Navigate back to sign-in from sign-up
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(appStateModel.currentState, AppState.signIn);
    });

    testWidgets('glassmorphism styling is consistent across screens', (WidgetTester tester) async {
      final appStateModel = AppStateModel();
      appStateModel.navigateToState(AppState.signIn);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SmartBudgetApp(),
        ),
      );

      // Verify glassmorphism elements on sign-in screen
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);

      // Navigate to sign-up screen
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify glassmorphism elements on sign-up screen
      expect(find.byType(TextFormField), findsNWidgets(4)); // Name, email, password, confirm password fields
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });
  });
}