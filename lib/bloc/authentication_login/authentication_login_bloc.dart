import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/staff_has_permission.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/admin_details.dart';
import '../../utils/project_constant.dart';

part 'authentication_login_event.dart';

part 'authentication_login_repository.dart';

part 'authentication_login_state.dart';

class AuthenticationLoginBloc extends Bloc<AuthenticationLoginEvent, AuthenticationLoginState> {
  AuthenticationLoginRepository authenticationLoginRepository = AuthenticationLoginRepository();

  AuthenticationLoginBloc() : super(AuthenticationLoginInitialState()) {
    on<AuthenticationLoggedInEvent>(_authenticationLoggedInEvent);
    on<AuthenticationLoggedOut>(_authenticationLoggedOut);
    on<AuthenticationAutoLoggedInEvent>(_authenticationAutoLoggedInEvent);
  }

  void _authenticationLoggedInEvent(AuthenticationLoggedInEvent event, Emitter<AuthenticationLoginState> emit) async {
    emit(AuthenticationLoginLoadingState());
    try {
      await authenticationLoginRepository.login(event.data);
      if (authenticationLoginRepository.message == 'Success') {
        final sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(
          'user',
          jsonEncode(AdminDetails.toJson(authenticationLoginRepository.adminDetails)),
        );
        emit(AuthenticationLoginSuccessState(
          adminDetails: authenticationLoginRepository.adminDetails,
          message: authenticationLoginRepository.message,
        ));
      } else {
        emit(AuthenticationLoginFailureState(
          authenticationLoginRepository.message,
        ));
      }
    } catch (error) {
      emit(AuthenticationLoginExceptionState(
        authenticationLoginRepository.message,
      ));
    }
  }

  void _authenticationAutoLoggedInEvent(AuthenticationAutoLoggedInEvent event, Emitter<AuthenticationLoginState> emit) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.containsKey('user')) {
        String? userStr = sharedPreferences.getString('user');
        if (userStr!.isNotEmpty) {
          AdminDetails? users = AdminDetails.fromJson(jsonDecode(userStr));
          await authenticationLoginRepository.login({
            'email': users.email,
            'password': users.password,
          });
          if (authenticationLoginRepository.message == 'Success') {
            final sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString(
              'user',
              jsonEncode(AdminDetails.toJson(authenticationLoginRepository.adminDetails)),
            );
            emit(AuthenticationLoginSuccessState(
              adminDetails: authenticationLoginRepository.adminDetails,
              message: authenticationLoginRepository.message,
            ));
          } else {
            emit(AuthenticationLoginFailureState(
              authenticationLoginRepository.message,
            ));
          }
        } else {
          emit(AuthenticationLoginFailureState('Login Failed'));
        }
      } else {
        emit(AuthenticationLoginFailureState('Login Failed'));
      }
    } catch (error) {
      print(error);
      emit(AuthenticationLoginExceptionState(
        authenticationLoginRepository.message,
      ));
    }
  }

  void _authenticationLoggedOut(AuthenticationLoggedOut event, Emitter<AuthenticationLoginState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('user');
    emit(AuthenticationLoginFailureState('Logged Out'));
  }
}
