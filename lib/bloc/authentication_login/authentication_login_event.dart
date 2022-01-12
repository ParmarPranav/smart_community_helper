part of 'authentication_login_bloc.dart';

abstract class AuthenticationLoginEvent extends Equatable {
  const AuthenticationLoginEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationAutoLoggedInEvent extends AuthenticationLoginEvent {}

class AuthenticationLoggedInEvent extends AuthenticationLoginEvent {
  final Map<String, dynamic> data;

  AuthenticationLoggedInEvent({required this.data});
}

class AuthenticationLoggedOut extends AuthenticationLoginEvent {}
