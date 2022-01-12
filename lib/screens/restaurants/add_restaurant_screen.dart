import 'package:flutter/material.dart';

import '../responsive_layout.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({Key? key}) : super(key: key);

  @override
  _AddRestaurantScreenState createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResponsiveLayout(
          smallScreen: _buildMobileTabletView(),
          mediumScreen: _buildMobileTabletView(),
          largeScreen: _buildWebView(),
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
