import 'package:flutter/material.dart';

import '../responsive_layout.dart';

class ManageRestaurantsScreen extends StatefulWidget {
  ManageRestaurantsScreen({Key? key}) : super(key: key);

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
