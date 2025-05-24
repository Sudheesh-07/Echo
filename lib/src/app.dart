import 'package:echo/src/core/routes/app_router.dart';
import 'package:echo/src/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// MyApp is the main application widget which extends StatelessWidget.
class MyApp extends StatelessWidget {
  /// Constructs a MyApp widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // ignore: lines_longer_than_80_chars
      routerConfig: AppRouters.router, // The home page will be the on in the app router file [AppRouters]
      builder: (BuildContext context, Widget? child) {
        final Brightness brightness = MediaQuery.of(context).platformBrightness;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor:
                brightness == Brightness.dark
                    ? darkTheme.appBarTheme.backgroundColor
                    : lightTheme.appBarTheme.backgroundColor,
            statusBarIconBrightness:
                brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
            statusBarBrightness:
                brightness == Brightness.dark
                    ? Brightness.dark
                    : Brightness.light,
          ),
        );

        return child!;
      },
    );
}
