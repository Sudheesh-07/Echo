import 'package:echo/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // This ensures the widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

// This ensures the orientation is always portrait
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
