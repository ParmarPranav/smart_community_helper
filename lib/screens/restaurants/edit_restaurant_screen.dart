import 'package:flutter/material.dart';

import '../responsive_layout.dart';

class EditRestaurantScreen extends StatefulWidget {
  const EditRestaurantScreen({Key? key}) : super(key: key);

  @override
  _EditRestaurantScreenState createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
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
