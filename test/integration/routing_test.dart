import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartbudget_ai/app/app.dart';
import 'package:smartbudget_ai/app/routes.dart' as routes;
import 'package:smartbudget_ai/shared/services/app_state_model.dart';
import 'package:smartbudget_ai/shared/services/navigation_service.dart';

void main() {
  group('Routing and Guards', () {
    testWidgets('initial route reflects app state', (tester) async {
      final appState = AppStateModel();
      appState.navigateToState(AppState.signIn, validate: false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appState,
          child: const SmartBudgetApp(useExternalAppState: true),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      // We should be on sign-in route
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets(
      'guard prevents navigating to dashboard when not authenticated',
      (tester) async {
        final appState = AppStateModel();
        appState.navigateToState(AppState.signIn, validate: false);
        await tester.pumpWidget(
          ChangeNotifierProvider<AppStateModel>.value(
            value: appState,
            child: const SmartBudgetApp(useExternalAppState: true),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        // Try to navigate directly to dashboard
        NavigationService.pushNamed(routes.AppRoutes.dashboard);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        // Should still be on sign-in (guarded)
        expect(find.text('Welcome Back'), findsOneWidget);
      },
    );

    testWidgets('navigates to dashboard after authentication', (tester) async {
      final appState = AppStateModel();
      appState.navigateToState(AppState.signIn, validate: false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateModel>.value(
          value: appState,
          child: const SmartBudgetApp(useExternalAppState: true),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Complete authentication
      appState.completeAuthentication();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Navigate to dashboard route explicitly
      NavigationService.pushReplacementNamed(routes.AppRoutes.dashboard);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Welcome to SmartBudget AI'), findsOneWidget);
    });
  });
}
