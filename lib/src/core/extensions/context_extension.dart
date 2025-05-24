import 'package:flutter/material.dart';

/// Convenient extension on [BuildContext]
/// for common UI properties and utilities.
extension BuildContextExtension on BuildContext {
  /// Returns the current [ColorScheme] from the theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the current [TextTheme] from the theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

/// Returns the current [ThemeData] from the theme.
  Brightness get theme => Theme.of(this).brightness;

  /// Returns the size of the current media (screen).
  Size get size => MediaQuery.of(this).size;

  /// Returns the width of the current screen.
  double get width => size.width;

  /// Returns the height of the current screen.
  double get height => size.height;
}

/// Pops the current route from the navigation stack.
void pop(BuildContext context) {
  Navigator.of(context).pop();
}
