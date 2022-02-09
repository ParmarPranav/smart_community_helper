import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/screens/crop_image_web_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_boy/manage_delivery_boy_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_boy/view_delivery_boy_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/add_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/edit_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/manage_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/add_restaurant_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/edit_restaurant_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_category/manage_food_category_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/add_food_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/edit_food_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/manage_food_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/liquor_category/manage_liquor_category_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/liquor_item/add_liquor_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/liquor_item/edit_liquor_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/liquor_item/manage_liquor_item_screen.dart';
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
      case ManageLiquorCategoryScreen.routeName:
        return _getPageRoute(
          child: ManageLiquorCategoryScreen(),
          settings: settings,
        );
      case ManageFoodItemScreen.routeName:
        return _getPageRoute(
          child: ManageFoodItemScreen(),
          settings: settings,
        );
      case ManageLiquorItemScreen.routeName:
        return _getPageRoute(
          child: ManageLiquorItemScreen(),
          settings: settings,
        );
      case AddFoodItemScreen.routeName:
        return _getPageRoute(
          child: AddFoodItemScreen(),
          settings: settings,
        );
      case EditFoodItemScreen.routeName:
        return _getPageRoute(
          child: EditFoodItemScreen(),
          settings: settings,
        );
        case AddLiquorItemScreen.routeName:
        return _getPageRoute(
          child: AddLiquorItemScreen(),
          settings: settings,
        );
      case EditLiquorItemScreen.routeName:
        return _getPageRoute(
          child: EditLiquorItemScreen(),
          settings: settings,
        );
      case ManageDeliveryBoyScreen.routeName:
        return _getPageRoute(
          child: ManageDeliveryBoyScreen(),
          settings: settings,
        );
      case ViewDeliveryBoyScreen.routeName:
        return _getPageRoute(
          child: ViewDeliveryBoyScreen(),
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
