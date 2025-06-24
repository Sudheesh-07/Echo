import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Displays a loading dialog with a circular progress indicator.
///
/// The dialog prevents user interaction by setting `barrierDismissible` to false
/// and intercepts back navigation using `WillPopScope`.
///
/// [context] is the BuildContext to display the dialog.
Future<T?> showLoading<T>(BuildContext context) => showDialog<T>(
  context: context,
  barrierDismissible: false, // Prevents dialog dismissal on tapping outside.
  barrierColor: Colors.black.withValues(
    alpha: 0.3,
  ), // Semi-transparent background.
  builder:
      (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: DotLottieLoader.fromAsset(
                AppImages.loadingAnimation,
                frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                  if (dotlottie != null) {
                    return Lottie.memory(dotlottie.animations.values.single);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
);
