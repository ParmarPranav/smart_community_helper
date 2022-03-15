import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../utils/project_constant.dart';

class OrderFoodWidget extends StatefulWidget {
  final int index;
  final FoodOrder orderFood;

  OrderFoodWidget({
    required this.index,
    required this.orderFood,
  });

  @override
  _OrderFoodWidgetState createState() => _OrderFoodWidgetState();
}

class _OrderFoodWidgetState extends State<OrderFoodWidget> {

  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            height: 50,
            width: 50,
            child: Image.asset(
              'assets/images/Cup_cake.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          widget.orderFood.name,
          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 20, fontColor: Colors.black),
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                Text(
                  'Price',
                  style: ProjectConstant.WorkSansFontRegularTextStyle(fontSize: 14, fontColor: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '\$${widget.orderFood!.finalPrice.toString()}',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Text(
                  'Qty',
                  style: ProjectConstant.WorkSansFontRegularTextStyle(fontSize: 14, fontColor: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.orderFood!.quantity.toString()}',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.black),
                )
              ],
            ),
          ],
        ),
        trailing: AnimatedRotation(
          duration: Duration(milliseconds: 300),
          turns: _isExpanded ? 0.5 : 0,
          child: Icon(Icons.keyboard_arrow_down,size: 32,),
        ),
        onExpansionChanged: (value){
          setState(() {
            _isExpanded =value;
          });
        },
        children: [
          Text(
            widget.orderFood.choosableIngredients,
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.orderFood.extraIngredients,
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
