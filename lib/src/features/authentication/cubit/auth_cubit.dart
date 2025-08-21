import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/features/authentication/cubit/auth_state.dart';
import 'package:echo/src/features/authentication/models/user_model.dart';
import 'package:echo/src/services/auth_services.dart';
import 'package:echo/src/services/user_service.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

/// Cubit for authentication state
class AuthCubit extends Cubit<AuthState> {
  /// Constructor for AuthCubit
  AuthCubit() : super(const AuthInitial());

  /// Authentication Services
  late final AuthService _authService = AuthService();
  late final UserService _userService = UserService();

  /// Send OTP function
  Future<void> sendOtp({required String email}) async {
    try {
      emit(const AuthLoading());
      final String response = await _authService.sendOtp(email);
      if (response.contains('Otp Sent')) {
        emit(AuthOtpSent(email));
      }
      if (response.contains('Too many requests')) {
        emit(const AuthError('Too many requests.'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Verify OTP that was sent
  Future<String> verifyOtp({required String email, required String otp}) async {
    try {
      emit(const AuthLoading());
      final String response = await _authService.verifyOtp(email, otp);
      if (response == 'Token saved Success') {
        emit(const AuthOtpVerified());
        final String userName = await getUserName();
        emit(AuthUserNameReady(userName));
        return 'Success';
      } else {
        emit(AuthError(response));
        return 'Error';
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
      return 'Error';
    }
  }

  /// Get random UserName
  Future<String> getUserName() async {
    try {
      final String response = await _authService.getUserName();
      return response;
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
      return 'Error';
    }
  }

  /// Save/Register the User
  Future<String> registerUser(
    String userName,
    String gender,
    XFile profilePic,
  ) async {
    try {
      final UserModel? user = await _authService.saveUser(
        username: userName,
       gender:  gender,
        profileImage:  profilePic,
      );
      if (user != null) {
        emit(AuthUserRegistered(user));
        return 'User Saved successfully';
      } else {
        throw Exception('User not found');
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
      return 'Error';
    }
  }
}
