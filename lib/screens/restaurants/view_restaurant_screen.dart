import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/screens/order/manage_order_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_category/manage_food_category_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/manage_food_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/liquor_category/manage_liquor_category_screen.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';

import '../responsive_layout.dart';
import 'liquor_item/manage_liquor_item_screen.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
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

  Widget _buildMobileTabletView() {
    return Container();
  }

  Widget _buildWebView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: BackButtonNew(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant!.name,
                      style: ProjectConstant.WorkSansFontBoldTextStyle(
                        fontSize: 26,
                        fontColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    restaurant!.restaurantType == 'food'
                        ? Text(
                            'Food',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 18,
                              fontColor: Colors.black,
                            ),
                          )
                        : Text(
                            'Food & Liquor',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 18,
                              fontColor: Colors.black,
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${restaurant!.address}, ${restaurant!.city}, ${restaurant!.country}',
                      style: ProjectConstant.WorkSansFontRegularTextStyle(
                        fontSize: 16,
                        fontColor: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      restaurant!.mobileNo,
                      style: ProjectConstant.WorkSansFontRegularTextStyle(
                        fontSize: 16,
                        fontColor: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      restaurant!.description,
                      style: ProjectConstant.WorkSansFontRegularTextStyle(
                        fontSize: 16,
                        fontColor: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.amberAccent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              RatingBar.builder(
                                initialRating: 4,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                unratedColor: Colors.grey.shade400,
                                itemSize: 14,
                                glow: true,
                                glowColor: Colors.amberAccent,
                                itemPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              SizedBox(width: 5),
                              Text(
                                '15',
                                style: ProjectConstant.WorkSansFontRegularTextStyle(
                                  fontSize: 16,
                                  fontColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: DottedDecoration(shape: Shape.circle),
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(85),
                      child: Image.network(
                        './images/restaurant_business_logo_images/${restaurant!.businessLogo}',
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              thickness: 1.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          if (restaurant!.restaurantType == 'food')
            Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Food Categories',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(ManageFoodCategoryScreen.routeName, arguments: restaurant);
                          },
                          child: Text(
                            'Manage',
                            style: ProjectConstant.WorkSansFontRegularTextStyle(
                              fontSize: 16,
                              fontColor: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Food Items',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(ManageFoodItemScreen.routeName,arguments: restaurant);
                          },
                          child: Text(
                            'Manage',
                            style: ProjectConstant.WorkSansFontRegularTextStyle(
                              fontSize: 16,
                              fontColor: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
          if (restaurant!.restaurantType == 'liquor')
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Liquor Categories',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 16,
                              fontColor: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(ManageLiquorCategoryScreen.routeName,arguments: restaurant);

                            },
                            child: Text(
                              'Manage',
                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                fontSize: 16,
                                fontColor: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Liquor Items',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 16,
                              fontColor: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(ManageLiquorItemScreen.routeName,arguments: restaurant);

                            },
                            child: Text(
                              'Manage',
                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                fontSize: 16,
                                fontColor: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ManageOrderScreen.routeName, arguments: restaurant);
                      },
                      child: Text(
                        'Manage',
                        style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 16,
                          fontColor: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
