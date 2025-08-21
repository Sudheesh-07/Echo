// ignore_for_file: lines_longer_than_80_chars

import 'package:echo/src/features/authentication/models/user_model.dart';
import 'package:equatable/equatable.dart';

/// Base class for all authentication states.
abstract class AuthState extends Equatable {
  /// Const constructor for [AuthState].
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial auth state.
class AuthInitial extends AuthState {
  /// Const constructor for [AuthInitial].
  const AuthInitial();
}

/// State when auth is loading.
class AuthLoading extends AuthState {
  /// Const constructor for [AuthLoading].
  const AuthLoading();
}

/// State for auth error.
class AuthError extends AuthState {
  /// Const constructor for [AuthError].
  const AuthError(this.message);

  /// Error message.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// State when OTP is sent.
class AuthOtpSent extends AuthState {
  ///Constructor for [AuthOtpSent].
  const AuthOtpSent(this.email);

  /// Email address.
  final String email;

  // If you create two instances:
  // const state1 = AuthOtpSent('test@example.com');
  // const state2 = AuthOtpSent('test@example.com');
  // Without this props override, state1 == state2 would return false because
  //they're different instances.
  //With the props override (assuming the parent class uses it for equality comparison),
  //they'll be considered equal because their email properties are equal.
  @override
  List<Object?> get props => <Object?>[email];
}

/// State when OTP is verified.
class AuthOtpVerified extends AuthState {
  /// Const constructor for [AuthOtpVerified].
  const AuthOtpVerified();

  @override
  List<Object?> get props => <Object?>[];
}

/// State when user name is ready.
class AuthUserNameReady extends AuthState {
  /// Const constructor for [AuthUserNameReady].
  const AuthUserNameReady(this.userName);

  /// User name.
  final String userName;

  @override
  List<Object?> get props => <Object?>[userName];
}

class AuthUserRegistered extends AuthState {
  /// Constructor
  const AuthUserRegistered(this.user);

  /// The user detail
  final UserModel? user;
  @override
  List<Object?> get props => <Object?>[user];
}

/// Extension to get current user from state.
extension AuthStateUserExtension on AuthState {
  /// Current authenticated user if present.
  UserModel? get currentUser => switch (this) {
      AuthUserRegistered(user: final UserModel user) => user,
      _ => null,
    };
}
