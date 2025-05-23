import 'package:echo/src/features/authentication/view/login_page.dart';
import 'package:echo/src/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      builder: (context, child) {
        final brightness = MediaQuery.of(context).platformBrightness;

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
}
