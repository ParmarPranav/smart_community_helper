import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';

import '../responsive_layout.dart';

class ViewRestaurantScreen extends StatefulWidget {

  static const routeName = '/view-restaurant';

  ViewRestaurantScreen({Key? key}) : super(key: key);

  @override
  _ViewRestaurantScreenState createState() => _ViewRestaurantScreenState();
}

class _ViewRestaurantScreenState extends State<ViewRestaurantScreen> {

  bool _isInit = true;
  Restaurant? restaurant;

  @override
  void initState() {
    super.initState();
    if(_isInit){
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        smallScreen: _buildMobileTabletView(),
        mediumScreen: _buildMobileTabletView(),
        largeScreen: _buildWebView(),
      ),
    );
  }

  Widget _buildMobileTabletView(){
    return Container();
  }

  Widget _buildWebView(){
    return Container();
  }
}
