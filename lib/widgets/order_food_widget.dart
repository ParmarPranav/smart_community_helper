import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';

import '../models/order.dart';
import '../utils/project_constant.dart';

class OrderFoodWidget extends StatefulWidget {
  final int index;
  final OrderFood orderFood;

  OrderFoodWidget({
    required this.index,
    required this.orderFood,
  });

  @override
  _OrderFoodWidgetState createState() => _OrderFoodWidgetState();
}

class _OrderFoodWidgetState extends State<OrderFoodWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                    imageUrl: '${ProjectConstant.food_images_path}${widget.orderFood.image}',
                    fit: BoxFit.cover,
                    placeholder: (context, value) {
                      return Container(
                        height: 40,
                        width: 40,
                        child: SkeletonView(),
                      );
                    },
                    errorWidget: (context, value, value2) {
                      return Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.orderFood.quantity} x ${widget.orderFood.name}',
                            style: ProjectConstant.WorkSansFontMediumTextStyle(
                              fontSize: 15,
                              fontColor: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '\$${widget.orderFood.totalPrice.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${widget.orderFood.basePrice.toString()}',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 14,
                            fontColor: Colors.red.shade700,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          if (widget.orderFood.removableIngredients != '' || widget.orderFood.orderExtraIngredientsList.length > 0 || widget.orderFood.orderComboOfferIngredientsList.length > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.orderFood.removableIngredients != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text(
                        'Removable Ingredients',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 13,
                          fontColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      ExpandableText(
                        '${widget.orderFood.removableIngredients}',
                        style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 12.0,
                          fontColor: Colors.black,
                        ),
                        animation: true,
                        expandText: 'more',
                        collapseText: 'less',
                        maxLines: 1,
                        linkColor: Colors.red,
                        linkStyle: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 12.0,
                          fontColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                if (widget.orderFood.orderExtraIngredientsList.length > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text(
                        'Extra Ingredients',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 13,
                          fontColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      ExpandableText(
                        widget.orderFood.orderExtraIngredientsList.map((e) => '${e.name}').toList().join(","),
                        style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 12.0,
                          fontColor: Colors.black,
                        ),
                        animation: true,
                        expandText: 'more',
                        collapseText: 'less',
                        maxLines: 1,
                        linkColor: Colors.red,
                        linkStyle: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 12.0,
                          fontColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                if (widget.orderFood.orderComboOfferIngredientsList.length > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text(
                        'Combo Offer Ingredients',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 13,
                          fontColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      ExpandableText(
                        widget.orderFood.orderComboOfferIngredientsList.map((e) => '${e.name}').toList().join(","),
                        style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 12.0,
                          fontColor: Colors.black,
                        ),
                        animation: true,
                        expandText: 'more',
                        collapseText: 'less',
                        maxLines: 1,
                        linkColor: Colors.red,
                        linkStyle: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 12.0,
                          fontColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            )
        ],
      ),
    );
  }
}
