import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/core/routes/route_observer.dart';
import 'package:echo/src/features/authentication/view/authentication_page.dart';
import 'package:echo/src/features/authentication/view/get_started_page.dart';
import 'package:echo/src/features/authentication/view/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///This class contains all routers and sub router for the app
class AppRouters {
  /// Navigator key for the router
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// Return current context of the app
  static BuildContext? get context => navigatorKey.currentContext;

  /// Observer for the current route
  static CurrentRouteObserver currentRouteObserver = CurrentRouteObserver();

  // The route configuration.
  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.initial,
    observers: <NavigatorObserver>[currentRouteObserver],
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder:
            (BuildContext context, GoRouterState state) =>
                const GetStartedPage(),
      ),
      GoRoute(
        path: AppRoutes.authentication,
        builder:
            (BuildContext context, GoRouterState state) =>
                AuthenticationPage(isLogIn: state.extra! as bool),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder:
            (BuildContext context, GoRouterState state) =>
                OtpScreen(email: state.extra! as String),
      ),
    ],
  );

  ///return object of the router
  static GoRouter get router => _router;
}
