import 'package:flutter/material.dart';

/// Utility class for displaying snackbars in the app.
///
/// Provides methods for showing success, error, and informational messages
/// using the `ScaffoldMessenger`.
class SnackbarUtils {
  /// Private constructor to prevent instantiation.
  SnackbarUtils._();

  /// Shows a success snackbar with green background.
  ///
  /// [context] is the BuildContext from which the snackbar is shown.
  /// [message] is the text to display inside the snackbar.
  /// [duration] is the optional display duration (default 3 seconds).
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message,
      backgroundColor: Colors.green,
      duration: duration,
    );
  }

  /// Shows an error snackbar with red background.
  ///
  /// [context] is the BuildContext from which the snackbar is shown.
  /// [message] is the text to display inside the snackbar.
  /// [duration] is the optional display duration (default 3 seconds).
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message,
      backgroundColor: Colors.red,
      duration: duration,
    );
  }

  /// Shows an informational snackbar with a neutral background color.
  ///
  /// [context] is the BuildContext from which the snackbar is shown.
  /// [message] is the text to display inside the snackbar.
  /// [duration] is the optional display duration (default 3 seconds).
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message,
      backgroundColor: Colors.blueGrey,
      duration: duration,
    );
  }

  /// Internal helper method for showing a snackbar.
  ///
  /// [context] is the BuildContext for displaying the snackbar.
  /// [message] is the text content of the snackbar.
  /// [backgroundColor] is the background color of the snackbar.
  /// [duration] is how long the snackbar will remain visible.
  static void _showSnackbar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Duration duration,
  }) {
    final SnackBar snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 130, // Positions near top
        left: 16,
        right: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
