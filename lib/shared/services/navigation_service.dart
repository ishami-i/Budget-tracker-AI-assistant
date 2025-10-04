import 'package:flutter/material.dart';

/// Global navigation service to allow navigation without BuildContext
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get _navigator => navigatorKey.currentState;

  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?>? pushReplacementNamed<
    T extends Object?,
    TO extends Object?
  >(String routeName, {TO? result, Object? arguments}) {
    return _navigator?.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  static Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator?.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    _navigator?.pop<T>(result);
  }
}
