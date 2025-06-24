// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ui';
import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/core/utils/widgets/elevated_button.dart';
import 'package:echo/src/core/utils/widgets/loading_animation.dart';
import 'package:echo/src/core/utils/widgets/snackbarutils.dart';
import 'package:echo/src/features/authentication/cubit/auth_cubit.dart';
import 'package:echo/src/features/authentication/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

/// Register and Login Page based on the isLogIn parameter
class AuthenticationPage extends StatefulWidget {
  ///This is the constructor
  const AuthenticationPage({required this.isLogIn, super.key});

  /// Register and Login Page based on the isLogIn parameter
  final bool isLogIn;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController emailController = TextEditingController();
  //This is to make the Email field unfocus when hitting register button
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    body: SizedBox(
      width: context.width,
      height: context.height,
      child: Stack(
        children: <Widget>[
          // Top gradient circle
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    context.theme == Brightness.dark
                        ? const AssetImage(AppImages.loginBgDark)
                        : const AssetImage(AppImages.loginBgLight),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  if (context.theme == Brightness.dark)
                    Colors.black.withOpacity(0.2)
                  else
                    context.colorScheme.primary.withOpacity(0.2),
                  if (context.theme == Brightness.dark)
                    Colors.black.withOpacity(0.7)
                  else
                    context.colorScheme.primary.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Center(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (BuildContext context, AuthState state) {
                if (state is AuthOtpSent) {
                  context.pop();
                  SnackbarUtils.showSuccess(
                    context,
                    'OTP sent successfully to ${emailController.text}',
                  );
                  context.go(AppRoutes.otp, extra: emailController.text);
                } else if (state is AuthError) {
                  context.pop();
                  SnackbarUtils.showError(context, state.message);
                } 
              },
              builder:
                  (BuildContext context, AuthState state) => Column(
                    children: <Widget>[
                      const Gap(180),
                      Padding(
                        padding: PaddingConstants.defaultPadding,
                        child: Text(
                          "What's your college email ID?",
                          style: context.textTheme.displayLarge!.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                      const Gap(30),
                      Padding(
                        padding: PaddingConstants.defaultPadding,
                        child: TextField(
                          focusNode: emailFocusNode,
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email Eg: username@universal.edu.in',
                            hintStyle: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorScheme.primaryFixedDim,
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Padding(
                        padding: PaddingConstants.defaultPadding,
                        child: Text(
                          // ignore: lines_longer_than_80_chars
                          'An email has will be sent to your college email for verification.',
                          style: context.textTheme.bodyMedium!.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: PaddingConstants.defaultPadding.copyWith(
                          bottom: 32,
                        ),
                        child: EchoButton(
                          label: widget.isLogIn ? 'Log In' : 'Register',
                          onPressed: onSubmit,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> onSubmit() async {
    //Using the same instance that was created in the main function
    final AuthCubit authCubit = context.read<AuthCubit>();
    unawaited(showLoading(context));
    emailFocusNode.unfocus();
    try {
      await HapticFeedback.mediumImpact();
      if (emailController.text.isNotEmpty) {
        await authCubit.sendOtp(email: emailController.text);
      } else {
        SnackbarUtils.showError(context, 'Please enter email');
      }
    } on Exception catch (e) {
      // Optional: Add error haptic feedback
      await HapticFeedback.heavyImpact();

      if (mounted) {
        SnackbarUtils.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    }
  }
}
