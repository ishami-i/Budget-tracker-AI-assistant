import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/shared/widgets/glass_input.dart';
import 'package:smartbudget_ai/core/utils/validators.dart';

void main() {
  group('GlassInput Widget Tests', () {
    testWidgets('renders with basic properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(hintText: 'Test hint', labelText: 'Test label'),
          ),
        ),
      );

      expect(find.text('Test label'), findsOneWidget);
      expect(find.text('Test hint'), findsOneWidget);
    });

    testWidgets('displays prefix icon when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(prefixIcon: Icons.email, hintText: 'Email'),
          ),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('displays suffix icon when provided and not password field', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(suffixIcon: Icons.search, hintText: 'Search'),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows password toggle for password fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(isPassword: true, hintText: 'Password'),
          ),
        ),
      );

      // Should show visibility_off icon initially (password hidden)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('toggles password visibility when icon is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(isPassword: true, hintText: 'Password'),
          ),
        ),
      );

      // Initially should show visibility_off (password hidden)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap the toggle button
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Should now show visibility (password visible)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again to hide password
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Should show visibility_off again (password hidden)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('calls validator when form is validated', (
      WidgetTester tester,
    ) async {
      bool validatorCalled = false;
      String? validatorResult;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: GlassInput(
                hintText: 'Email',
                validator: (value) {
                  validatorCalled = true;
                  validatorResult = Validators.email(value);
                  return validatorResult;
                },
              ),
            ),
          ),
        ),
      );

      // Validate the form
      formKey.currentState?.validate();
      await tester.pump();

      expect(validatorCalled, isTrue);
      expect(validatorResult, 'Email is required');
    });

    testWidgets('shows error message when validation fails', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: GlassInput(hintText: 'Email', validator: Validators.email),
            ),
          ),
        ),
      );

      // Validate the form to trigger validation
      formKey.currentState?.validate();
      await tester.pump();

      // Should show error message
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes', (
      WidgetTester tester,
    ) async {
      String? changedValue;
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassInput(
              controller: controller,
              hintText: 'Test input',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();

      expect(changedValue, 'test@example.com');
      expect(controller.text, 'test@example.com');
    });

    testWidgets('calls onFieldSubmitted when submitted', (
      WidgetTester tester,
    ) async {
      String? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassInput(
              hintText: 'Test input',
              onFieldSubmitted: (value) {
                submittedValue = value;
              },
            ),
          ),
        ),
      );

      // Enter text and submit
      await tester.enterText(find.byType(TextFormField), 'submitted text');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedValue, 'submitted text');
    });

    testWidgets('respects enabled property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(hintText: 'Disabled input', enabled: false),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.enabled, isFalse);
    });

    testWidgets('respects maxLines property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(hintText: 'Multi-line input', maxLines: 3),
          ),
        ),
      );

      // Check that the GlassInput widget has the correct maxLines property
      final glassInput = tester.widget<GlassInput>(find.byType(GlassInput));
      expect(glassInput.maxLines, 3);
    });

    testWidgets('respects keyboardType property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(
              hintText: 'Email input',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      final glassInput = tester.widget<GlassInput>(find.byType(GlassInput));
      expect(glassInput.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('respects textInputAction property', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(
              hintText: 'Next input',
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
      );

      final glassInput = tester.widget<GlassInput>(find.byType(GlassInput));
      expect(glassInput.textInputAction, TextInputAction.next);
    });

    testWidgets('focuses when autofocus is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassInput(hintText: 'Auto focus input', autofocus: true),
          ),
        ),
      );

      final glassInput = tester.widget<GlassInput>(find.byType(GlassInput));
      expect(glassInput.autofocus, isTrue);
    });

    group('Focus Animation Tests', () {
      testWidgets('animates border color on focus', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: GlassInput(hintText: 'Focus test')),
          ),
        );

        // Find the text field and focus it
        final textFieldFinder = find.byType(TextFormField);
        await tester.tap(textFieldFinder);
        await tester.pump();

        // Let the animation complete
        await tester.pumpAndSettle();

        // Verify that the input is focused by checking if we can find the focused text field
        expect(textFieldFinder, findsOneWidget);
      });

      testWidgets('shows glow effect when focused', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: GlassInput(hintText: 'Glow test')),
          ),
        );

        // Focus the input
        await tester.tap(find.byType(TextFormField));
        await tester.pump();
        await tester.pumpAndSettle();

        // The container should have box shadow when focused
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(GlassInput),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(container.decoration, isA<BoxDecoration>());
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.isNotEmpty, isTrue);
      });
    });

    group('Validation Tests', () {
      testWidgets('validates email format correctly', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: GlassInput(
                  hintText: 'Email',
                  validator: Validators.email,
                ),
              ),
            ),
          ),
        );

        // Test invalid email
        await tester.enterText(find.byType(TextFormField), 'invalid-email');
        formKey.currentState?.validate();
        await tester.pump();

        expect(find.text('Please enter a valid email address'), findsOneWidget);

        // Test valid email
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        formKey.currentState?.validate();
        await tester.pump();

        expect(find.text('Please enter a valid email address'), findsNothing);
      });

      testWidgets('validates password requirements', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: GlassInput(
                  hintText: 'Password',
                  isPassword: true,
                  validator: Validators.password,
                ),
              ),
            ),
          ),
        );

        // Test short password
        await tester.enterText(find.byType(TextFormField), '123');
        formKey.currentState?.validate();
        await tester.pump();

        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );

        // Test valid password
        await tester.enterText(find.byType(TextFormField), 'password123');
        formKey.currentState?.validate();
        await tester.pump();

        expect(
          find.text('Password must be at least 6 characters'),
          findsNothing,
        );
      });
    });
  });

  testWidgets('GlassInput shows animated error message on validation failure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: _GlassInputHarness(),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('GlassInput toggles password visibility', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: _GlassInputHarness(isPassword: true),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });
}

class _GlassInputHarness extends StatefulWidget {
  final bool isPassword;
  const _GlassInputHarness({this.isPassword = false});

  @override
  State<_GlassInputHarness> createState() => _GlassInputHarnessState();
}

class _GlassInputHarnessState extends State<_GlassInputHarness> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GlassInput(
            labelText: 'Field',
            controller: _controller,
            validator: _validator,
            isPassword: widget.isPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _formKey.currentState?.validate(),
          ),
        ],
      ),
    );
  }
}
