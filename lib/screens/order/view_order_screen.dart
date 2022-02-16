import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../widgets/order_food_widget.dart';

class ViewOrderScreen extends StatefulWidget {
  static const routeName = '/view-order';

  ViewOrderScreen({Key? key}) : super(key: key);

  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  bool _isInit = true;
  Order? order;
  bool validate = false;

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      order = ModalRoute.of(context)!.settings.arguments as Order;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Order Detail',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
              fontSize: 16,
              fontColor: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Order#',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${order!.orderNo.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 20, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Date',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(order!.createdAt),
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: order!.orderFoodList.length,
                  itemBuilder: (context, index) {
                    return OrderFoodWidget(index: index + 1, orderFood: order!.orderFoodList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Bill Details',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gross Total',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ ${order!.itemTotalPrice.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Charge',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ ${order!.serviceCharge.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount Amount',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ ${order!.serviceCharge.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tax Total',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ ${order!.serviceCharge.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Charge',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ ${order!.serviceCharge.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tip Amount',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 14, fontColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ ${order!.serviceCharge.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 18,
                            fontColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        
                        Text(
                          '\$ ${order!.grandTotal.toString()}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 18,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Delivery Instruction',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          order!.deliveryInstruction,
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackMessage(String message, Color color, [int seconds = 3]) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
