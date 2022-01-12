part of 'authentication_login_bloc.dart';

abstract class AuthenticationLoginState extends Equatable {
  const AuthenticationLoginState();

  @override
  List<Object> get props => [];
}

class AuthenticationLoginInitialState extends AuthenticationLoginState {}

class AuthenticationLoginLoadingState extends AuthenticationLoginState {}

class AuthenticationLoginSuccessState extends AuthenticationLoginState {
  final AdminDetails? adminDetails;
  final String message;

  AuthenticationLoginSuccessState({
    required this.adminDetails,
    required this.message,
  });
}

class AuthenticationLoginFailureState extends AuthenticationLoginState {
  final String message;

  AuthenticationLoginFailureState(this.message);
}

class AuthenticationLoginExceptionState extends AuthenticationLoginState {
  final String message;

  AuthenticationLoginExceptionState(this.message);
}
