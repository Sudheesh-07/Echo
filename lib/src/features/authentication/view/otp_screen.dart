// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/core/utils/widgets/snackbarutils.dart';
import 'package:echo/src/features/authentication/cubit/auth_cubit.dart';
import 'package:echo/src/features/authentication/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

/// Register and Login Page based on the isLogIn parameter
class OtpScreen extends StatefulWidget {
  ///This is the constructor
  const OtpScreen({required this.email, super.key});

  /// Register and Login Page based on the isLogIn parameter
  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final AuthCubit authCubit = AuthCubit();
  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinFocusNode);
    });
  }

  @override
  void dispose() {
    _pinFocusNode.dispose();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: <Widget>[
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
              child: BlocListener<AuthCubit, AuthState>(
                listener: (BuildContext context, AuthState state) {
                  if (state is AuthOtpVerified) {
                    SnackbarUtils.showSuccess(
                      context,
                      'OTP verified successfully',
                    );
                    
                  }else if (state is AuthError) {
                    SnackbarUtils.showError(
                      context,
                      state.message,
                    );
                  }
                  else if (state is AuthLoading) {
                    
                  }
                },
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
                      focusNode: _pinFocusNode,
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
                        onSubmit();
                      },
                    ),
                    const Gap(10),
                    Padding(
                      padding: PaddingConstants.defaultPadding,
                      child: Text(
                        // ignore: lines_longer_than_80_chars
                        'An email has been sent to ${widget.email} Please check your inbox nad spam folder',
                        style: context.textTheme.bodyMedium!.copyWith(
                          height: 1.5,
                        ),
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
  }

  Future<void> onSubmit() async {
    await HapticFeedback.heavyImpact();
    try {
      if (_otpController.text.isNotEmpty) {
        await authCubit.verifyOtp(
          email: widget.email,
          otp: _otpController.text,
        );
        SnackbarUtils.showSuccess(context, 'OTP verified successfully');
      }
    } on Exception catch (e) {
      await HapticFeedback.vibrate().then((_) => HapticFeedback.mediumImpact());
      SnackbarUtils.showError(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
