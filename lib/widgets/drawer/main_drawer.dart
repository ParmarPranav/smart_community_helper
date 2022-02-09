import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/screens/account_type/manage_account_type_screen.dart';
import 'package:food_hunt_admin_app/screens/coupons/manage_coupons_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/manage_restaurants_screen.dart';
import 'package:food_hunt_admin_app/screens/staff/manage_staff_screen.dart';

import '../../bloc/authentication_login/authentication_login_bloc.dart';
import '../../models/admin_details.dart';
import '../../screens/home_screen.dart';
import '../../screens/responsive_layout.dart';
import 'drawer_list_tile.dart';

class MainDrawer extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  MainDrawer({
    required this.navigatorKey,
  });

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool _isInit = true;
  AdminDetails? adminDetails;

  bool _isGroupAccessible(String accessName) {
    adminDetails = BlocProvider.of<AuthenticationLoginBloc>(context).authenticationLoginRepository.adminDetails;
    // return adminDetails.permissionsList.any((permission) => permission.groupName == accessName);
    return true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      adminDetails = BlocProvider.of<AuthenticationLoginBloc>(context).authenticationLoginRepository.adminDetails;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationLoginBloc, AuthenticationLoginState>(
      listener: (context, state) {
        if (state is AuthenticationLoginFailureState) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      },
      builder: (context, state) {
        return Drawer(
          child: Container(
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.blueGrey[900],
                          elevation: 1,
                          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  margin: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      "assets/images/app_logo.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        divider(thickness: 0.5),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (adminDetails?.accountType.toLowerCase() == 'admin' || adminDetails?.accountType.toLowerCase() == 'owner')
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.home_outlined,
                                      title: "Dashboard",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        Navigator.of(widget.navigatorKey!.currentContext as BuildContext).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                              if (adminDetails?.accountType.toLowerCase() == 'admin' || adminDetails?.accountType.toLowerCase() == 'owner')
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.people,
                                      title: "Manage Staff",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        Navigator.of(widget.navigatorKey!.currentContext as BuildContext).pushNamedAndRemoveUntil(ManageStaffScreen.routeName, (route) => false);
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                              if (adminDetails?.accountType.toLowerCase() == 'admin' || adminDetails?.accountType.toLowerCase() == 'owner')
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.people,
                                      title: "Manage Account Type",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        Navigator.of(widget.navigatorKey!.currentContext as BuildContext).pushNamedAndRemoveUntil(ManageAccountTypeScreen.routeName, (route) => false);
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                              if (adminDetails?.accountType.toLowerCase() == 'admin' || adminDetails?.accountType.toLowerCase() == 'owner')
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.people,
                                      title: "Manage Restaurants",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        Navigator.of(widget.navigatorKey!.currentContext as BuildContext).pushNamedAndRemoveUntil(ManageRestaurantScreen.routeName, (route) => false);
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                              if (adminDetails?.accountType.toLowerCase() == 'admin' || adminDetails?.accountType.toLowerCase() == 'owner')
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.people,
                                      title: "Manage Delivery Boy",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        Navigator.of(widget.navigatorKey!.currentContext as BuildContext).pushNamedAndRemoveUntil(ManageRestaurantScreen.routeName, (route) => false);
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                              if (adminDetails?.accountType.toLowerCase() == 'admin' || adminDetails?.accountType.toLowerCase() == 'owner')
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.local_offer,
                                      title: "Manage Coupons",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        Navigator.of(widget.navigatorKey!.currentContext as BuildContext).pushNamedAndRemoveUntil(ManageCouponsScreen.routeName, (route) => false);
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                              if (state is AuthenticationLoginSuccessState)
                                Column(
                                  children: [
                                    DrawerListTile(
                                      iconData: Icons.power_settings_new,
                                      title: "Log Out",
                                      itemHandler: () {
                                        if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        BlocProvider.of<AuthenticationLoginBloc>(context).add(AuthenticationLoggedOut());
                                      },
                                    ),
                                    divider(thickness: 0.5),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSnackMessage(String message) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget divider({
    double thickness = 1.0,
    double height = 1.0,
  }) {
    return Divider(
      color: Colors.blueGrey[700],
      thickness: thickness,
      height: height,
    );
  }

// void _onLogOut(AuthProvider authProvider) async {
//   await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Are you sure?'),
//       content: Text('Do you want to logout from App ?'),
//       actions: <Widget>[
//         FlatButton(
//           onPressed: () => Navigator.of(context).pop(false),
//           child: Text('No'),
//         ),
//         FlatButton(
//           onPressed: () {
//             Navigator.of(context).pop(true);
//             Navigator.of(context).pushReplacementNamed("/");
//             authProvider.logout();
//           },
//           child: Text('Yes'),
//         ),
//       ],
//     ),
//   );
// }
}
