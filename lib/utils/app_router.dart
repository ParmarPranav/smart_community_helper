import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/screens/crop_image_web_screen.dart';
import 'package:food_hunt_admin_app/screens/home_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/add_restaurant_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/edit_restaurant_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_category/manage_food_category_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/manage_restaurants_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/view_restaurant_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/add_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/edit_staff_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/manage_staff_screen.dart';

import '../screens/account_type/add_account_type_screen.dart';
import '../screens/account_type/edit_account_type_screen.dart';
import '../screens/account_type/manage_account_type_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings, GlobalKey<NavigatorState> navigatorKey) {
    switch (settings.name) {
      case '/':
        return _getPageRoute(
          child: ManageRestaurantScreen(),
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
      case ManageRestaurantScreen.routeName:
        return _getPageRoute(
          child: ManageRestaurantScreen(),
          settings: settings,
        );
      case AddRestaurantScreen.routeName:
        return _getPageRoute(
          child: AddRestaurantScreen(),
          settings: settings,
        );
      case EditRestaurantScreen.routeName:
        return _getPageRoute(
          child: EditRestaurantScreen(),
          settings: settings,
        );
      case CropImageWebScreen.routeName:
        return _getPageRoute(
          child: CropImageWebScreen(),
          settings: settings,
        );
      case ViewRestaurantScreen.routeName:
        return _getPageRoute(
          child: ViewRestaurantScreen(),
          settings: settings,
        );
      case ManageFoodCategoryScreen.routeName:
        return _getPageRoute(
          child: ManageFoodCategoryScreen(),
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
