// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';

import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/core/utils/widgets/elevated_button.dart';
import 'package:echo/src/core/utils/widgets/loading_animation.dart';
import 'package:echo/src/core/utils/widgets/snackbarutils.dart';
import 'package:echo/src/features/authentication/cubit/auth_cubit.dart';
import 'package:echo/src/features/authentication/cubit/auth_state.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

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
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'sudheeshshetty48@gmail.com' : '',
  );
  //This is to make the Email field unfocus when hitting register button
  FocusNode emailFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  bool otpScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(otpFocusNode);
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PinTheme defaultPinTheme = PinTheme(
      width: 63,
      height: 63,
      textStyle: context.textTheme.titleMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
        color: context.colorScheme.surface,
      ),
    );
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthLoading) {
          unawaited(showLoading(context));
        } else if (state is AuthOtpSent) {
          context.pop();
          // SnackbarUtils.showSuccess(
          //   context,
          //   'OTP sent successfully to ${emailController.text}',
          //   duration: ,
          // );
          setState(() {
            otpScreen = true;
          });
        } else if (state is AuthOtpVerified) {
          context.pop();
          SnackbarUtils.showSuccess(
            context,
            'OTP verified successfully',
          );
          if (widget.isLogIn) {
            context.go(AppRoutes.home);
          }
        } else if (state is AuthUserNameReady) {
          if (!widget.isLogIn) {
            showProfilePopup(state.userName);
          }
        } else if (state is AuthError) {
          context.pop();
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: SizedBox(
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
                if (otpScreen)
                  Center(
                    child: Column(
                      children: <Widget>[
                        const Gap(200),
                        Padding(
                          padding: PaddingConstants.defaultPadding,
                          child: Text(
                            "Just sent a email, what's the code?",
                            style: context.textTheme.displayLarge,
                          ),
                        ),
                        const Gap(30),
                        Pinput(
                          length: 5,
                          controller: _otpController,
                          focusNode: otpFocusNode,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the code';
                            }
                            if (value.length != 5) {
                              return 'Code must be 5 digits';
                            }
                            return null;
                          },
                          onCompleted: (String pin) {
                            verifyOtp();
                          },
                        ),
                        const Gap(10),
                        Padding(
                          padding: PaddingConstants.defaultPadding,
                          child: Text(
                            // ignore: lines_longer_than_80_chars
                            'An email has been sent to ${emailController.text} Please check your inbox and spam folder',
                            style: context.textTheme.bodyMedium!.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Center(
                    child: Column(
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
                            onPressed: sendOtp,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    //Using the same instance that was created in the main function
    final AuthCubit authCubit = context.read<AuthCubit>();
    //unawaited(showLoading(context));
    emailFocusNode.unfocus();
    try {
      await HapticFeedback.mediumImpact();
      if (emailController.text.isNotEmpty &&
          emailController.text.contains('@')) {
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

  Future<void> verifyOtp() async {
    final AuthCubit authCubit = context.read<AuthCubit>();
    await HapticFeedback.heavyImpact();
    try {
      if (_otpController.text.isNotEmpty) {
        await authCubit.verifyOtp(
          email: emailController.text,
          otp: _otpController.text,
        );
      }
    } on Exception catch (e) {
      await HapticFeedback.vibrate().then((_) => HapticFeedback.mediumImpact());
      SnackbarUtils.showError(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void showProfilePopup(String username) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => ProfileBottomSheet(username: username),
    );
  }
}
