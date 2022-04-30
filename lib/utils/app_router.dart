import 'package:flutter/material.dart';

import 'package:food_hunt_admin_app/screens/crop_image_web_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_boy/add_delivery_boy_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_boy/manage_delivery_boy_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/add_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/edit_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/manage_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/add_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/edit_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/manage_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/user/add_user_screen.dart';
import 'package:food_hunt_admin_app/screens/user/edit_user_screen.dart';
import 'package:food_hunt_admin_app/screens/user/manage_user_screen.dart';

import '../screens/account_type/add_account_type_screen.dart';
import '../screens/account_type/edit_account_type_screen.dart';
import '../screens/account_type/manage_account_type_screen.dart';
import '../screens/manage_general_setting_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings, GlobalKey<NavigatorState> navigatorKey) {
    switch (settings.name) {
      case '/':
        return _getPageRoute(
          child: ManageUsersScreen(),
          settings: settings,
        );
      case ManageAccountTypeScreen.routeName:
        return _getPageRoute(
          child: ManageAccountTypeScreen(),
          settings: settings,
        );
      case AddAccountTypeScreen.routeName:
        return _getPageRoute(
          child: AddAccountTypeScreen(),
          settings: settings,
        );
      case EditAccountTypeScreen.routeName:
        return _getPageRoute(
          child: EditAccountTypeScreen(),
          settings: settings,
        );
      case ManageStaffScreen.routeName:
        return _getPageRoute(
          child: ManageStaffScreen(),
          settings: settings,
        );
      case AddStaffScreen.routeName:
        return _getPageRoute(
          child: AddStaffScreen(),
          settings: settings,
        );
      case EditStaffScreen.routeName:
        return _getPageRoute(
          child: EditStaffScreen(),
          settings: settings,
        );

      case CropImageWebScreen.routeName:
        return _getPageRoute(
          child: CropImageWebScreen(),
          settings: settings,
        );


      case ManageDeliveryBoyScreen.routeName:
        return _getPageRoute(
          child: ManageDeliveryBoyScreen(),
          settings: settings,
        );

      case ManageDeliveryChargesScreen.routeName:
        return _getPageRoute(
          child: ManageDeliveryChargesScreen(),
          settings: settings,
        );
      case AddDeliveryChargesScreen.routeName:
        return _getPageRoute(
          child: AddDeliveryChargesScreen(),
          settings: settings,
        );
      case EditDeliveryChargesScreen.routeName:
        return _getPageRoute(
          child: EditDeliveryChargesScreen(),
          settings: settings,
        );
      case ManageUsersScreen.routeName:
        return _getPageRoute(
          child: ManageUsersScreen(),
          settings: settings,
        );
      case AddUserScreen.routeName:
        return _getPageRoute(
          child: AddUserScreen(),
          settings: settings,
        );
      case EditUserScreen.routeName:
        return _getPageRoute(
          child: EditUserScreen(),
          settings: settings,
        );
      case AddDeliveryBoyScreen.routeName:
        return _getPageRoute(
          child: AddDeliveryBoyScreen(),
          settings: settings,
        );

      case GeneralSettingScreen.routeName:
        return _getPageRoute(
          child: GeneralSettingScreen(),
          settings: settings,
        );

    }
  }

  void dispose() {}

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
