import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/screens/staff/add_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/edit_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/manage_staff_screen.dart';

import '../bloc/authentication_login/authentication_login_bloc.dart';
import '../bloc/get_account_type_drop_down/get_account_type_drop_down_bloc.dart';
import '../screens/account_type/add_account_type_screen.dart';
import '../screens/account_type/edit_account_type_screen.dart';
import '../screens/account_type/manage_account_type_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
  final AuthenticationLoginBloc _authenticationLoginBloc = AuthenticationLoginBloc();
  final GetAccountTypeDropDownBloc _getAccountTypeDropDownBloc = GetAccountTypeDropDownBloc();

  Route? onGenerateRoute(RouteSettings settings, GlobalKey<NavigatorState> navigatorKey) {
    switch (settings.name) {
      case '/':
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: HomeScreen(),
          ),
          settings: settings,
        );
      case ManageAccountTypeScreen.routeName:
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: ManageAccountTypeScreen(),
          ),
          settings: settings,
        );
      case AddAccountTypeScreen.routeName:
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: AddAccountTypeScreen(),
          ),
          settings: settings,
        );
      case EditAccountTypeScreen.routeName:
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: EditAccountTypeScreen(),
          ),
          settings: settings,
        );
      case ManageStaffScreen.routeName:
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: ManageStaffScreen(),
          ),
          settings: settings,
        );
      case AddStaffScreen.routeName:
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: AddStaffScreen(),
          ),
          settings: settings,
        );
      case EditStaffScreen.routeName:
        return _getPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _authenticationLoginBloc,
              ),
            ],
            child: EditStaffScreen(),
          ),
          settings: settings,
        );
    }
  }

  void dispose() {
    _authenticationLoginBloc.close();
    _getAccountTypeDropDownBloc.close();
  }

  PageRoute _getPageRoute({
    required Widget child,
    required RouteSettings settings,
  }) {
    return _FadeRoute(
      child: child,
      routeName: settings.name,
      arguments: settings.arguments,
    );
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String? routeName;
  final Object? arguments;

  _FadeRoute({required this.child, required this.routeName, required this.arguments})
      : super(
          settings: RouteSettings(name: routeName, arguments: arguments),
          pageBuilder: (context, animation, secondaryAnimation) {
            return child;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
