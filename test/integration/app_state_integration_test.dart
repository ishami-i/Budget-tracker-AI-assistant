import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbudget_ai/shared/services/services.dart';

void main() {
  group('App State Integration Tests', () {
    testWidgets('Provider integration works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => AppStateModel(),
            child: Consumer<AppStateModel>(
              builder: (context, appState, child) {
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'State: ${appState.currentState.toString().split('.').last}',
                        ),
                        Text('Loading: ${appState.isLoading}'),
                        if (appState.errorMessage != null)
                          Text('Error: ${appState.errorMessage}'),
                        ElevatedButton(
                          onPressed: () => appState.completeOnboarding(),
                          child: const Text('Complete Onboarding'),
                        ),
                        ElevatedButton(
                          onPressed: () => appState.navigateToSignUp(),
                          child: const Text('Go to Sign Up'),
                        ),
                        ElevatedButton(
                          onPressed:
                              () => appState.setLoading(!appState.isLoading),
                          child: Text(
                            appState.isLoading
                                ? 'Stop Loading'
                                : 'Start Loading',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => appState.setError('Test error'),
                          child: const Text('Set Error'),
                        ),
                        ElevatedButton(
                          onPressed: () => appState.clearError(),
                          child: const Text('Clear Error'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('State: onboarding'), findsOneWidget);
      expect(find.text('Loading: false'), findsOneWidget);

      // Test state change
      await tester.tap(find.text('Complete Onboarding'));
      await tester.pump();

      expect(find.text('State: signIn'), findsOneWidget);

      // Test navigation to sign up
      await tester.tap(find.text('Go to Sign Up'));
      await tester.pump();

      expect(find.text('State: signUp'), findsOneWidget);

      // Test loading state
      await tester.tap(find.text('Start Loading'));
      await tester.pump();

      expect(find.text('Loading: true'), findsOneWidget);
      expect(find.text('Stop Loading'), findsOneWidget);

      await tester.tap(find.text('Stop Loading'));
      await tester.pump();

      expect(find.text('Loading: false'), findsOneWidget);

      // Test error handling
      await tester.tap(find.text('Set Error'));
      await tester.pump();

      expect(find.text('Error: Test error'), findsOneWidget);

      await tester.tap(find.text('Clear Error'));
      await tester.pump();

      expect(find.text('Error: Test error'), findsNothing);
    });

    testWidgets('Invalid state transitions show errors', (
      WidgetTester tester,
    ) async {
      final appStateModel = AppStateModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: appStateModel,
            child: Consumer<AppStateModel>(
              builder: (context, appState, child) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text(
                        'State: ${appState.currentState.toString().split('.').last}',
                      ),
                      if (appState.errorMessage != null)
                        Text('Error: ${appState.errorMessage}'),
                      ElevatedButton(
                        onPressed:
                            () => appState.navigateToState(AppState.dashboard),
                        child: const Text('Invalid Transition'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Try invalid transition from onboarding to dashboard
      await tester.tap(find.text('Invalid Transition'));
      await tester.pump();

      // Should still be in onboarding state
      expect(find.text('State: onboarding'), findsOneWidget);
      // Should show error
      expect(find.textContaining('Invalid state transition'), findsOneWidget);

      appStateModel.dispose();
    });

    testWidgets('Async operations work correctly', (WidgetTester tester) async {
      final appStateModel = AppStateModel();
      bool operationCompleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: appStateModel,
            child: Consumer<AppStateModel>(
              builder: (context, appState, child) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text('Loading: ${appState.isLoading}'),
                      if (appState.errorMessage != null)
                        Text('Error: ${appState.errorMessage}'),
                      ElevatedButton(
                        onPressed: () {
                          appState.performAsyncOperation<String>(
                            () async {
                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                              return 'Success';
                            },
                            onSuccess: (result) {
                              operationCompleted = true;
                            },
                          );
                        },
                        child: const Text('Test Async'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Test async operation
      await tester.tap(find.text('Test Async'));
      await tester.pump();

      // Should show loading
      expect(find.text('Loading: true'), findsOneWidget);

      // Wait for operation to complete
      await tester.pump(const Duration(milliseconds: 200));

      // Loading should be gone and operation completed
      expect(find.text('Loading: false'), findsOneWidget);
      expect(operationCompleted, true);

      appStateModel.dispose();
    });

    test('AppStateModel persists and restores state', () async {
      SharedPreferences.setMockInitialValues({});
      final model = AppStateModel();
      await model.initialize();
      expect(model.currentState, AppState.onboarding);

      model.completeOnboarding();
      expect(model.currentState, AppState.signIn);

      // Simulate new instance reading persisted value
      final model2 = AppStateModel();
      await model2.initialize();
      expect(model2.currentState, AppState.signIn);
    });
  });
}
