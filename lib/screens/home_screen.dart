import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../bloc/authentication_login/authentication_login_bloc.dart';
import '../widgets/drawer/main_drawer.dart';
import 'responsive_layout.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: Scaffold(
          drawer: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
              ? MainDrawer(
                  navigatorKey: Navigator.of(context).widget.key as GlobalKey<NavigatorState>,
                )
              : null,
          body: ResponsiveLayout(
            largeScreen: _buildWebView(screenHeight, screenWidth, mediaQuery),
            mediumScreen: _buildTabletView(screenHeight, screenWidth, mediaQuery),
            smallScreen: _buildMobileView(screenHeight, screenWidth, mediaQuery),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(double screenHeight, double screenWidth, MediaQueryData mediaQuery) {
    return BlocBuilder<AuthenticationLoginBloc, AuthenticationLoginState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(''),
              pinned: false,
              snap: false,
              leading: null,
              automaticallyImplyLeading: false,
              expandedHeight: 70,
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Theme.of(context).backgroundColor,
              floating: true,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildMobileTabletHeaderWidget(screenWidth, state, context),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          _cardWidget(
                            title: 'Total Orders',
                            value: '2050',
                            icon: FeatherIcons.shoppingCart,
                            mediaQueryData: mediaQuery,
                            colors: [Colors.lightBlueAccent, Colors.blue],
                            cardWidth: mediaQuery.size.width * 0.18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          _cardWidget(
                            title: 'Total Earnings',
                            value: '3250',
                            icon: Icons.account_balance_wallet_outlined,
                            mediaQueryData: mediaQuery,
                            colors: [Colors.pinkAccent, Colors.deepOrangeAccent],
                            cardWidth: mediaQuery.size.width * 0.18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          _cardWidget(
                            title: 'Total Revenue',
                            value: '87.5%',
                            icon: FeatherIcons.pieChart,
                            mediaQueryData: mediaQuery,
                            colors: [Colors.lightGreen, Colors.green],
                            cardWidth: mediaQuery.size.width * 0.18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          _cardWidget(
                            title: 'Total Orders',
                            value: '2050',
                            icon: FeatherIcons.user,
                            mediaQueryData: mediaQuery,
                            colors: [Colors.amberAccent, Colors.orange],
                            cardWidth: mediaQuery.size.width * 0.18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildTabletView(double screenHeight, double screenWidth, MediaQueryData mediaQuery) {
    return BlocBuilder<AuthenticationLoginBloc, AuthenticationLoginState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(''),
              pinned: false,
              snap: false,
              expandedHeight: 70,
              leading: null,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Theme.of(context).backgroundColor,
              floating: true,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildMobileTabletHeaderWidget(screenWidth, state, context),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: _cardWidget(
                                title: 'Total Orders',
                                value: '2050',
                                icon: FeatherIcons.shoppingCart,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.lightBlueAccent, Colors.blue],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: _cardWidget(
                                title: 'Total Earnings',
                                value: '3250',
                                icon: Icons.account_balance_wallet_outlined,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.pinkAccent, Colors.deepOrangeAccent],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: _cardWidget(
                                title: 'Total Revenue',
                                value: '87.5%',
                                icon: FeatherIcons.pieChart,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.lightGreen, Colors.green],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: _cardWidget(
                                title: 'Total Orders',
                                value: '2050',
                                icon: FeatherIcons.user,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.amberAccent, Colors.orange],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebView(double screenHeight, double screenWidth, MediaQueryData mediaQuery) {
    return BlocBuilder<AuthenticationLoginBloc, AuthenticationLoginState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(''),
              pinned: false,
              snap: false,
              leading: null,
              automaticallyImplyLeading: false,
              expandedHeight: 80,
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Theme.of(context).backgroundColor,
              floating: true,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildWebHeaderWidget(screenWidth, state, context),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _cardWidget(
                                title: 'Total Orders',
                                value: '2050',
                                icon: FeatherIcons.shoppingCart,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.lightBlueAccent, Colors.blue],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              _cardWidget(
                                title: 'Total Earnings',
                                value: '3250',
                                icon: Icons.account_balance_wallet_outlined,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.pinkAccent, Colors.deepOrangeAccent],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              _cardWidget(
                                title: 'Total Revenue',
                                value: '87.5%',
                                icon: FeatherIcons.pieChart,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.lightGreen, Colors.green],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              _cardWidget(
                                title: 'Total Orders',
                                value: '2050',
                                icon: FeatherIcons.user,
                                mediaQueryData: mediaQuery,
                                colors: [Colors.amberAccent, Colors.orange],
                                cardWidth: mediaQuery.size.width * 0.18,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _cardWidget({
    required String title,
    required String value,
    required List<Color> colors,
    required IconData icon,
    required MediaQueryData mediaQueryData,
    required double cardWidth,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            minWidth: cardWidth,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabletHeaderWidget(double screenWidth, AuthenticationLoginState state, BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Colors.red,
            Colors.pinkAccent,
            Colors.deepOrangeAccent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 120,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      filterQuality: FilterQuality.medium,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 10,
              ),
              if (state is AuthenticationLoginSuccessState)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text("My Account"), value: 0),
                          PopupMenuItem(child: Text("Log out"), value: 1),
                        ];
                      },
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
                            break;
                          case 1:
                            BlocProvider.of<AuthenticationLoginBloc>(context).add(AuthenticationLoggedOut());
                            break;
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWebHeaderWidget(double screenWidth, AuthenticationLoginState state, BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Colors.red,
            Colors.pinkAccent,
            Colors.deepOrangeAccent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Row(
              children: const [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              if (state is AuthenticationLoginSuccessState)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text("My Account"), value: 0),
                          PopupMenuItem(child: Text("Log out"), value: 1),
                        ];
                      },
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
                            break;
                          case 1:
                            BlocProvider.of<AuthenticationLoginBloc>(context).add(AuthenticationLoggedOut());
                            break;
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
