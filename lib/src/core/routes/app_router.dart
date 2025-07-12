import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/core/routes/route_observer.dart';
import 'package:echo/src/features/authentication/view/authentication_page.dart';
import 'package:echo/src/features/authentication/view/get_started_page.dart';
import 'package:echo/src/features/authentication/view/navigation.dart';
import 'package:echo/src/features/authentication/view/otp_screen.dart';
import 'package:echo/src/features/posts/views/add_post.dart';
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

///This class contains all routers and sub router for the app
class AppRouters {
  /// Navigator key for the router
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// Return current context of the app
  static BuildContext? get context => navigatorKey.currentContext;

  /// Observer for the current route
  static CurrentRouteObserver currentRouteObserver = CurrentRouteObserver();

  /// Storage for the app
  static GetStorage storage = GetStorage();

  // The route configuration.
  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.home,
    // observers: <NavigatorObserver>[currentRouteObserver],
    //   redirect: (BuildContext context, GoRouterState state) {
    //   final String? token = storage.read<String>('token');

      
    //   final bool isLoggedIn = token != null && token.isNotEmpty;

    //   // if user tries to go to home but is not logged in
    //   if (!isLoggedIn && state.fullPath == AppRoutes.home) {
    //     return '/';
    //   }

    //   // if user is logged in but tries to access auth flow pages
    //   if (isLoggedIn &&
    //       (state.fullPath == '/' || state.fullPath!.startsWith('/auth'))) {
    //     return AppRoutes.home;
    //   }

    //   // no redirection needed
    //   return null;
    // },
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
      GoRoute(
        path: AppRoutes.home,
        builder:
            (BuildContext context, GoRouterState state) =>
                const Navigation()
      ),
      GoRoute(
        path: AppRoutes.addPost,
        builder:
            (BuildContext context, GoRouterState state) => const AddPostPage(),
      )
    ],
  );

  ///return object of the router
  static GoRouter get router => _router;
}
