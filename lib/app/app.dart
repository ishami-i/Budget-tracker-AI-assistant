import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/services/services.dart';
import '../shared/services/navigation_service.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart' as routes;

/// Main application widget with state management setup
class SmartBudgetApp extends StatelessWidget {
  /// If true, assumes an external Provider<AppStateModel> is already present
  /// and will not create its own provider. Useful for tests.
  final bool useExternalAppState;
  const SmartBudgetApp({super.key, this.useExternalAppState = false});

  @override
  Widget build(BuildContext context) {
    final materialAppBuilder = Consumer<AppStateModel>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'SmartBudget AI',
          theme: AppTheme.darkTheme,
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: routes.onGenerateRoute,
          initialRoute: _initialRouteFor(appState.currentState),
          debugShowCheckedModeBanner: false,
        );
      },
    );

    if (useExternalAppState) {
      return materialAppBuilder;
    }

    return ChangeNotifierProvider(
      create: (context) => AppStateModel()..initialize(),
      child: materialAppBuilder,
    );
  }

  // Removed old direct screen builder; routes now handle navigation

  String _initialRouteFor(AppState currentState) {
    switch (currentState) {
      case AppState.onboarding:
        return routes.AppRoutes.onboarding;
      case AppState.signIn:
        return routes.AppRoutes.signIn;
      case AppState.signUp:
        return routes.AppRoutes.signUp;
      case AppState.dashboard:
        return routes.AppRoutes.dashboard;
    }
  }
}
