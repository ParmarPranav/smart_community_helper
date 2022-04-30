import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/screens/main_screen.dart';

import '../bloc/authentication_login/authentication_login_bloc.dart';
import '../bloc/get_account_type_drop_down/get_account_type_drop_down_bloc.dart';
import '../screens/login_screen.dart';

class MainRouter {
  final AuthenticationLoginBloc _authenticationLoginBloc = AuthenticationLoginBloc();

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
  }
}
