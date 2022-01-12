import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/screens/responsive_layout.dart';
import 'package:food_hunt_admin_app/utils/app_router.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AppRouter _appRouter = AppRouter();
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState!.canPop()) {
          _navigatorKey.currentState!.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: ResponsiveLayout(
          largeScreen: _buildWebView(screenHeight, screenWidth),
          mediumScreen: _buildMobileTabletView(screenHeight, screenWidth),
          smallScreen: _buildMobileTabletView(screenHeight, screenWidth),
        ),
      ),
    );
  }

  Widget _buildMobileTabletView(double screenHeight, double screenWidth) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) => _appRouter.onGenerateRoute(settings, _navigatorKey),
    );
  }

  Widget _buildWebView(double screenHeight, double screenWidth) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.20,
          constraints: BoxConstraints(minWidth: 200),
          child: MainDrawer(
            navigatorKey: _navigatorKey,
          ),
        ),
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) => _appRouter.onGenerateRoute(settings, _navigatorKey),
          ),
        )
      ],
    );
  }
}
