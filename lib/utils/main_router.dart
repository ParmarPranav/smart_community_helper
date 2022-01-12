import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/screens/main_screen.dart';

import '../bloc/authentication_login/authentication_login_bloc.dart';
import '../bloc/get_account_type_drop_down/get_account_type_drop_down_bloc.dart';
import '../screens/account_type/add_account_type_screen.dart';
import '../screens/account_type/edit_account_type_screen.dart';
import '../screens/account_type/manage_account_type_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class MainRouter {
  final AuthenticationLoginBloc _authenticationLoginBloc = AuthenticationLoginBloc();
  final GetAccountTypeDropDownBloc _getAccountTypeDropDownBloc = GetAccountTypeDropDownBloc();

  Route? onGenerateRoute(RouteSettings settings, GlobalKey<NavigatorState> navigatorKey) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
              BlocProvider.value(
                value: _getAccountTypeDropDownBloc,
              ),
            ],
            child: LoginScreen(),
          ),
        );
      case MainScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: MainScreen(),
          ),
        );
    }
  }

  void dispose() {
    _authenticationLoginBloc.close();
    _getAccountTypeDropDownBloc.close();
  }
}
