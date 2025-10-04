import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/features/auth/screens/sign_up_screen.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('SignUpScreen', () {
    late AppStateModel appStateModel;

    setUp(() {
      appStateModel = AppStateModel();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AppStateModel>.value(
          value: appStateModel,
          child: const SignUpScreen(),
        ),
      );
    }

    testWidgets('displays sign-up form elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify the main elements are present
      expect(find.text('Create Account'), findsNWidgets(2)); // Title and button
      expect(find.text('Join SmartBudget AI to start managing your finances'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      // Check for the terms and conditions text by looking for GestureDetector containing RichText
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('shows validation errors for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Scroll to make the create account button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();

      // Tap the create account button without entering any data
      await tester.tap(find.text('Create Account').last); // Use .last to get the button, not the title
      await tester.pump();

      // Verify validation errors appear
      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows error when terms and conditions are not accepted', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Fill in all form fields
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe'); // Name
      await tester.enterText(textFields.at(1), 'test@example.com'); // Email
      await tester.enterText(textFields.at(2), 'password123'); // Password
      await tester.enterText(textFields.at(3), 'password123'); // Confirm Password
      
      // Scroll to make the create account button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pump();
      
      // Tap the create account button without accepting terms
      await tester.tap(find.text('Create Account').last);
      await tester.pump();

      // Verify terms and conditions error appears
      expect(find.text('Please accept the Terms and Conditions to continue'), findsOneWidget);
    });

    testWidgets('checkbox can be toggled by tapping checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Scroll to make the checkbox visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();

      // Initially checkbox should be unchecked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Checkbox should now be checked
      final checkedCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkedCheckbox.value, true);

      // Tap the checkbox again to toggle back
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Checkbox should be unchecked again
      final uncheckedCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(uncheckedCheckbox.value, false);
    });

    testWidgets('shows validation error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter invalid email
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe'); // Name
      await tester.enterText(textFields.at(1), 'invalid-email'); // Email
      await tester.enterText(textFields.at(2), 'password123'); // Password
      await tester.enterText(textFields.at(3), 'password123'); // Confirm Password
      
      // Scroll to make the create account button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();
      
      // Tap the create account button
      await tester.tap(find.text('Create Account').last); // Use .last to get the button, not the title
      await tester.pump();

      // Verify email validation error appears
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows validation error for short password', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter short password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe'); // Name
      await tester.enterText(textFields.at(1), 'test@example.com'); // Email
      await tester.enterText(textFields.at(2), '123'); // Password
      await tester.enterText(textFields.at(3), '123'); // Confirm Password
      
      // Scroll to make the create account button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();
      
      // Tap the create account button
      await tester.tap(find.text('Create Account').last); // Use .last to get the button, not the title
      await tester.pump();

      // Verify password validation error appears
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('shows validation error for password mismatch', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter mismatched passwords
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe'); // Name
      await tester.enterText(textFields.at(1), 'test@example.com'); // Email
      await tester.enterText(textFields.at(2), 'password123'); // Password
      await tester.enterText(textFields.at(3), 'differentpassword'); // Confirm Password
      
      // Scroll to make the create account button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();
      
      // Tap the create account button
      await tester.tap(find.text('Create Account').last); // Use .last to get the button, not the title
      await tester.pump();

      // Verify password mismatch error appears
      expect(find.text('Passwords do not match'), findsOneWidget);
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
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
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
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
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

    testWidgets('navigates to sign-in when sign-in link is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Scroll down to make the sign-in link visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -600));
      await tester.pump();

      // Verify initial state
      expect(appStateModel.currentState, AppState.onboarding);

      // Tap the sign-in link
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify navigation to sign-in
      expect(appStateModel.currentState, AppState.signIn);
    });

    testWidgets('password fields have visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter passwords
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'testpassword'); // Password
      await tester.enterText(textFields.at(3), 'testpassword'); // Confirm Password
      await tester.pump();

      // Initially should show visibility_off icons (passwords are hidden)
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      // Tap the first visibility toggle (password field)
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      // Should now show one visibility icon and one visibility_off icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('successful sign-up with terms accepted navigates to dashboard', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Fill in all form fields with valid data
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe'); // Name
      await tester.enterText(textFields.at(1), 'newuser@example.com'); // Email
      await tester.enterText(textFields.at(2), 'password123'); // Password
      await tester.enterText(textFields.at(3), 'password123'); // Confirm Password
      
      // Scroll to make the checkbox and button visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pump();
      
      // Accept terms and conditions
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      // Verify initial state
      expect(appStateModel.currentState, AppState.onboarding);
      
      // Tap the create account button
      await tester.tap(find.text('Create Account').last);
      
      // Wait for the async sign-up operation to complete
      // The AuthService has a 1-second delay, so we need to wait for that
      await tester.pump(); // Initial pump to start the async operation
      await tester.pump(const Duration(seconds: 2)); // Wait for the async operation
      
      // Verify navigation to dashboard
      expect(appStateModel.currentState, AppState.dashboard);
    });
  });
}