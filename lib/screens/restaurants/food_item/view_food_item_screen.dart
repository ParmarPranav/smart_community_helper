import 'dart:math';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';

import '../../responsive_layout.dart';

class ViewFoodItemScreen extends StatefulWidget {
  static const routeName = '/view-food-item';

  ViewFoodItemScreen({Key? key}) : super(key: key);

  @override
  _ViewFoodItemScreenState createState() => _ViewFoodItemScreenState();
}

class _ViewFoodItemScreenState extends State<ViewFoodItemScreen> {
  bool _isInit = true;
  FoodItem? foodItem;

  List _colors = [
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.amber,
    Colors.pink,
    Colors.green,
    Colors.blue,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      foodItem = ModalRoute.of(context)!.settings.arguments as FoodItem?;
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
          Container(
            width: 200,
            height: 170,
            decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                ProjectConstant.food_images_path + foodItem!.image,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            foodItem!.name,
            style: ProjectConstant.WorkSansFontBoldTextStyle(
              fontSize: 26,
              fontColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            foodItem!.foodCategoryName,
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 16,
              fontColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            foodItem!.foodType == 'veg' ? 'Vegetarian' : 'Non-Vegetarian',
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 16,
              fontColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            foodItem!.description,
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 16,
              fontColor: Colors.grey.shade600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: RatingBar.builder(
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
          SizedBox(
            width: 10,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                ExpansionTile(
                  title: Text(
                    'Removable Ingredients',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: foodItem!.removableIngredientsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                          foodItem!.removableIngredientsList[index].name,
                          style: ProjectConstant.WorkSansFontRegularTextStyle(fontSize: 14, fontColor: Colors.black),
                        ));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                ExpansionTile(
                  title: Text(
                    'Extra Ingredients',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                  ),
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: foodItem!.extraIngredientsMainCategoryList.length,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: _colors[Random().nextInt(_colors.length)],
                                radius: 15,
                                child: Text(
                                  '${index + 1}',
                                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                    fontSize: 14,
                                    fontColor: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                foodItem!.extraIngredientsMainCategoryList[index].name,
                                style: ProjectConstant.WorkSansFontMediumTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.black,
                                ),
                              ),
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 25),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: foodItem!.extraIngredientsMainCategoryList[index].extraIngredientsSubCategoryList.length,
                                    itemBuilder: (context, sindex) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: _colors[Random().nextInt(_colors.length)],
                                          radius: 15,
                                          child: Text(
                                            '${sindex + 1}',
                                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                              fontSize: 14,
                                              fontColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          foodItem!.extraIngredientsMainCategoryList[index].extraIngredientsSubCategoryList[sindex].name,
                                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                            fontSize: 14,
                                            fontColor: Colors.black,
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                              'Price: ${ProjectConstant.currencySymbol}${foodItem!.extraIngredientsMainCategoryList[index].extraIngredientsSubCategoryList[sindex].price}',
                                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                                fontSize: 13,
                                                fontColor: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'Original Price: ${ProjectConstant.currencySymbol}${foodItem!.extraIngredientsMainCategoryList[index].extraIngredientsSubCategoryList[sindex].originalPrice}',
                                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                                fontSize: 13,
                                                fontColor: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, sindex) {
                                      return Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                ExpansionTile(
                  title: Text(
                    'Combo Offers',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                  ),
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: foodItem!.comboOfferIngredientsMainCategoryList.length,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: _colors[Random().nextInt(_colors.length)],
                                radius: 15,
                                child: Text(
                                  '${index + 1}',
                                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                    fontSize: 14,
                                    fontColor: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                foodItem!.comboOfferIngredientsMainCategoryList[index].name,
                                style: ProjectConstant.WorkSansFontMediumTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.black,
                                ),
                              ),
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 25),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: foodItem!.comboOfferIngredientsMainCategoryList[index].comboOfferIngredientsSubCategoryList.length,
                                    itemBuilder: (context, sindex) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: _colors[Random().nextInt(_colors.length)],
                                          radius: 15,
                                          child: Text(
                                            '${sindex + 1}',
                                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                              fontSize: 14,
                                              fontColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          foodItem!.comboOfferIngredientsMainCategoryList[index].comboOfferIngredientsSubCategoryList[sindex].name,
                                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                            fontSize: 14,
                                            fontColor: Colors.black,
                                          ),
                                        ),
                                        subtitle:  Row(
                                          children: [
                                            Text(
                                              'Price: ${ProjectConstant.currencySymbol}${foodItem!.comboOfferIngredientsMainCategoryList[index].comboOfferIngredientsSubCategoryList[sindex].price}',
                                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                                fontSize: 13,
                                                fontColor: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'Original Price: ${ProjectConstant.currencySymbol}${foodItem!.comboOfferIngredientsMainCategoryList[index].comboOfferIngredientsSubCategoryList[sindex].originalPrice}',
                                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                                fontSize: 13,
                                                fontColor: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            if(foodItem!.comboOfferIngredientsMainCategoryList[index].comboOfferIngredientsSubCategoryList[sindex].isFree == '1')
                                              Row(
                                                children: [
                                                  Icon(Icons.check_circle,size: 16,color: Colors.green,),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text('It is Free',style: ProjectConstant.WorkSansFontRegularTextStyle(
                                                    fontSize: 13,
                                                    fontColor: Colors.green,
                                                  ),)
                                                ],
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, sindex){
                                      return Divider(height: 1,color: Colors.grey.shade300,);
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
