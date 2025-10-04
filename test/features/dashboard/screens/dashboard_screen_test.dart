import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('DashboardScreen', () {
    Widget createTestWidget() {
      return const MaterialApp(home: DashboardScreen());
    }

    testWidgets('renders header with animated logo and welcome text', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      // Initial pump and start animations
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Welcome to SmartBudget AI'), findsOneWidget);
      expect(find.text('Your financial overview at a glance'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);

      // Checkmark should appear after animation
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('renders at least 3 feature cards in grid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      // Avoid pumpAndSettle due to ongoing animations; pump a fixed duration instead
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Set Income'), findsOneWidget);
      expect(find.text('AI Analysis'), findsOneWidget);
      expect(find.text('Save More'), findsOneWidget);
    });

    testWidgets('tapping feature cards shows Coming Soon dialog', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Set Income'));
      await tester.pump();
      expect(find.text('Coming Soon'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pump();

      await tester.tap(find.text('AI Analysis'));
      await tester.pump();
      expect(find.text('Coming Soon'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pump();
    });

    testWidgets('shows Logout button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets(
      'tapping Logout triggers signOut (navigates to sign-in state)',
      (tester) async {
        final appState = AppStateModel();
        appState.navigateToState(AppState.dashboard, validate: false);
        await tester.pumpWidget(
          ChangeNotifierProvider<AppStateModel>.value(
            value: appState,
            child: const MaterialApp(home: DashboardScreen()),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        expect(appState.currentState, AppState.dashboard);
        await tester.tap(find.text('Logout'));
        await tester.pump();
        expect(appState.currentState, AppState.signIn);
      },
    );
  });
}
