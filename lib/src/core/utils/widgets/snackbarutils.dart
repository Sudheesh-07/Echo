import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

/// Utility class for displaying snack bars in the app.
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
      'Success',
      ContentType.success,
      Colors.green.shade700,
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
      'Error',
      ContentType.failure,
      Colors.red.shade900,
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
      'Oh Hey!',
      ContentType.help,
      Colors.amber.shade600,
    );
  }

  /// Internal helper method for showing a snackbar.
  ///
  /// [context] is the BuildContext for displaying the snackbar.
  /// [message] is the text content of the snackbar.
  /// [title] is the title of the snackbar.
  static void _showSnackbar(
    BuildContext context,
    String message,
    String title,
    ContentType contentType,
    Color color, ) {
    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 200,
        left: 20,
        right: 20,
      ),
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        color: color,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
