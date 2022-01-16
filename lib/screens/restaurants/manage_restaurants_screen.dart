import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/admin_details.dart';
import 'package:food_hunt_admin_app/screens/restaurants/add_restaurant_screen.dart';

import '../responsive_layout.dart';

class ManageRestaurantsScreen extends StatefulWidget {
  ManageRestaurantsScreen({Key? key}) : super(key: key);

  static const routeName = "/-manage-restaurants";

  @override
  _ManageRestaurantsScreenState createState() => _ManageRestaurantsScreenState();
}

class _ManageRestaurantsScreenState extends State<ManageRestaurantsScreen> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResponsiveLayout(
          smallScreen: _buildMobileTabletView(),
          mediumScreen: _buildMobileTabletView(),
          largeScreen: _buildWebView(),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 16, right: 16),
          child: FloatingActionButton(
            onPressed: () async {
              AdminDetails? staff = await Navigator.of(context).pushNamed(AddRestaurantScreen.routeName) as AdminDetails?;
              if (staff != null) {
                setState(() {
                 // _staffList.add(staff);
                });
              }
            },
            child: Icon(Icons.add),
          ),
        ),

      ),
    );
  }

  Widget _buildMobileTabletView() {
    return Container();
  }

  Widget _buildWebView() {
    return Container();
  }
}
