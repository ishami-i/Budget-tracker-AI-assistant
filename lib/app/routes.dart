import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../shared/services/app_state_model.dart';
import '../shared/services/navigation_service.dart';

/// Centralized route names
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String dashboard = '/dashboard';
}

/// Builds a fade transition route
PageRoute<T> _fadeRoute<T>(Widget page, RouteSettings settings) {
  return PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder:
        (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
  );
}

/// Navigation guards based on app state
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final context = NavigationService.navigatorKey.currentContext!;
  final appState = Provider.of<AppStateModel>(context, listen: false);
  final String name = settings.name ?? AppRoutes.onboarding;

  switch (name) {
    case AppRoutes.onboarding:
      // Only allow onboarding if not authenticated
      if (appState.currentState == AppState.dashboard) {
        return _fadeRoute(const DashboardScreen(), settings);
      }
      return _fadeRoute(const OnboardingScreen(), settings);
    case AppRoutes.signIn:
      if (appState.currentState == AppState.dashboard) {
        return _fadeRoute(const DashboardScreen(), settings);
      }
      return _fadeRoute(const SignInScreen(), settings);
    case AppRoutes.signUp:
      if (appState.currentState == AppState.dashboard) {
        return _fadeRoute(const DashboardScreen(), settings);
      }
      return _fadeRoute(const SignUpScreen(), settings);
    case AppRoutes.dashboard:
      if (appState.currentState != AppState.dashboard) {
        // Redirect to appropriate auth screen
        return _fadeRoute(const SignInScreen(), settings);
      }
      return _fadeRoute(const DashboardScreen(), settings);
    default:
      return _fadeRoute(const SignInScreen(), settings);
  }
}
