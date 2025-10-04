import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/app/app.dart';
import 'package:smartbudget_ai/app/routes.dart' as routes;
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  Future<void> pumpWithState(WidgetTester tester, AppState initial) async {
    final appState = AppStateModel();
    // Set initial state synchronously
    appState.navigateToState(initial, validate: false);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const SmartBudgetApp(useExternalAppState: true),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Onboarding -> SignIn route guard works', (tester) async {
    await pumpWithState(tester, AppState.onboarding);

    // Should be on onboarding route
    expect(find.byType(Scaffold), findsOneWidget);

    // Move to sign-in
    final state = Provider.of<AppStateModel>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    state.completeOnboarding();
    await tester.pumpAndSettle();

    // Now guards should navigate to sign-in
    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('SignIn -> Dashboard after completeAuthentication', (
    tester,
  ) async {
    await pumpWithState(tester, AppState.signIn);

    final state = Provider.of<AppStateModel>(
      tester.element(find.byType(Scaffold)),
      listen: false,
    );
    state.completeAuthentication();
    await tester.pumpAndSettle();

    // Expect to be on dashboard
    expect(find.text('Welcome to SmartBudget AI'), findsOneWidget);
  });

  testWidgets('Dashboard route guard prevents navigating to onboarding', (
    tester,
  ) async {
    await pumpWithState(tester, AppState.dashboard);

    // Simulate navigation request to onboarding
    final navigator = Navigator.of(tester.element(find.byType(Scaffold)));
    navigator.pushNamed(routes.AppRoutes.onboarding);
    await tester.pumpAndSettle();

    // Should still be on dashboard due to guard
    expect(find.text('Welcome to SmartBudget AI'), findsOneWidget);
  });
}
