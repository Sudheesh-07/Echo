import 'package:bloc/bloc.dart';
import 'package:echo/src/features/authentication/cubit/auth_state.dart';
import 'package:echo/src/services/auth_services.dart';

/// Cubit for authentication state
class AuthCubit extends Cubit<AuthState> {
  /// Constructor for AuthCubit
  AuthCubit() : super(const AuthInitial());

  /// Authentication Services
  late final AuthService _authService = AuthService();

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
      if (response == 'Success') {
        emit(const AuthOtpVerified());
        final String userName = await getUserName();
        emit(AuthUserNameReady(userName));
        return 'Success';
      }
      else {
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
}
