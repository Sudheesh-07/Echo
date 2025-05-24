import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A [NavigatorObserver] implementation to track the current route location.
///
/// This observer listens for push and pop events via the [GoRouter]'s
/// navigation stack and updates the current route's location string.
///
/// Usage:
/// ```dart
/// final router = GoRouter(
///   routes: [...],
///   observers: [CurrentRouteObserver()],
/// );
/// ```
class CurrentRouteObserver extends NavigatorObserver {
  /// The current active route's location path.
  String? location;

  /// Called when a new route has been pushed onto the navigation stack.
  ///
  /// Updates [location] to the newly pushed route's name and logs the event.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    location = route.settings.name;
  }

  /// Called when a route has been popped off the navigation stack.
  ///
  /// Updates [location] to the previous route's name and logs the event.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    location = previousRoute?.settings.name;
  }

  /// Called when a route is removed from the navigator.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when a route is replaced with a new one.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    location = newRoute?.settings.name;
  }

  /// Determines if the given [route] is the same as the current [location].
  ///
  /// If the [route] provided is not null and matches the current [location],
  /// this method returns `true`. Otherwise, it returns `false`.
  ///
  /// - Parameters:
  ///   - route: The route to compare with the current [location].
  ///
  /// - Returns: `true` if [route] is not null and equals the [location];
  ///   otherwise, returns `false`.
  bool isSame(String? route) =>
      route != null && location != null && route == location;
}
