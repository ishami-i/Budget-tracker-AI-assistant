import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/features/auth/screens/sign_in_screen.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('SignInScreen', () {
    late AppStateModel appStateModel;

    setUp(() {
      appStateModel = AppStateModel();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SignInScreen(),
        ),
      );
    }

    testWidgets('displays sign-in form elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify the main elements are present
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue to SmartBudget AI'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('shows validation errors for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap the sign-in button without entering any data
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify validation errors appear
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      // Tap the sign-in button
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify email validation error appears
      expect(find.text('Please enter a valid email address'), findsWidgets);
    });

    testWidgets('password field has visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter password
      await tester.enterText(find.byType(TextFormField).last, 'testpassword');
      await tester.pump();

      // Initially should show visibility_off icon (password is hidden)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap the visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Should now show visibility icon (password is visible)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows social sign-in buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify social sign-in buttons are present
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('shows coming soon dialog for Google sign-in', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Scroll down to make the Google button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();

      // Tap Google sign-in button
      await tester.tap(find.text('Continue with Google'));
      await tester.pump();

      // Verify coming soon dialog appears
      expect(find.text('Coming Soon'), findsOneWidget);
      expect(find.text('Google sign-in will be available in a future update.'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Tap OK to close dialog
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Verify dialog is closed
      expect(find.text('Coming Soon'), findsNothing);
    });

    testWidgets('shows coming soon dialog for Apple sign-in', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Scroll down to make the Apple button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pump();

      // Tap Apple sign-in button
      await tester.tap(find.text('Continue with Apple'));
      await tester.pump();

      // Verify coming soon dialog appears
      expect(find.text('Coming Soon'), findsOneWidget);
      expect(find.text('Apple sign-in will be available in a future update.'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Tap OK to close dialog
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Verify dialog is closed
      expect(find.text('Coming Soon'), findsNothing);
    });

    testWidgets('shows forgot password dialog', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap forgot password button
      await tester.tap(find.text('Forgot Password?'));
      await tester.pump();

      // Verify forgot password dialog appears
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Password reset functionality will be available in a future update.'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Tap OK to close dialog
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Verify dialog is closed
      expect(find.text('Forgot Password'), findsNothing);
    });

    testWidgets('navigates to sign-up when sign-up link is tapped', (WidgetTester tester) async {
      // Set initial state to sign-in to allow navigation to sign-up
      appStateModel.navigateToState(AppState.signIn);
      
      await tester.pumpWidget(createTestWidget());

      // Scroll down to make the sign-up link visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      // Verify initial state
      expect(appStateModel.currentState, AppState.signIn);

      // Tap the sign-up link
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Verify navigation to sign-up
      expect(appStateModel.currentState, AppState.signUp);
    });
  });
}