import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/utils/string_extension.dart';
import 'package:food_hunt_admin_app/widgets/order_liquor_widget.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../widgets/order_food_original_widget.dart';
import '../../widgets/order_food_widget.dart';
import '../../widgets/order_liquor_original_widget.dart';

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

  double originalItemTotal = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      order = ModalRoute.of(context)!.settings.arguments as Order;
      if (order!.foodType == 'food') {
        order!.orderFoodList.forEach((element) {
          double finalPrice = element.originalPrice;
          element.orderExtraIngredientsList.forEach((element) {
            finalPrice += element.originalPrice;
          });
          element.orderComboOfferIngredientsList.forEach((element) {
            finalPrice += element.originalPrice;
          });
          originalItemTotal += (finalPrice * element.quantity);
        });
      } else {
        order!.orderLiquorList.forEach((element) {
          originalItemTotal += (element.originalPrice * element.quantity);
        });
      }
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
          title: order != null
              ? Text(
                  '#${order!.orderNo.toString()}',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),
                )
              : Text(
                  '',
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
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order!.orderStatus == 'pending') _buildPendingStatusWidget(),
                    if (order!.orderStatus == 'accepted') _buildAcceptedStatusWidget(),
                    if (order!.orderStatus == 'rejected') _buildRejectedStatusWidget(),
                    if (order!.orderStatus == 'food_ready') _buildFoodReadyStatusWidget(),
                    if (order!.orderStatus == 'on_the_way') _buildOnTheWayStatusWidget(),
                    if (order!.orderStatus == 'delivered') _buildDeliveredStatusWidget(),
                    if (order!.orderStatus == 'not_delivered') _buildNotDeliveredStatusWidget(),
                    if (order!.orderStatus == 'pickedup') _buildPickedUpStatusWidget(),
                    if (order!.orderStatus == 'not_pickedup') _buildNotPickedUpStatusWidget(),
                    if (order!.orderStatus == 'cancelled') _buildCancelledStatusWidget(),
                    if (order!.orderStatus == 'failed') _buildFailedStatusWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: order!.paymentStatus == 'notpaid'
                            ? Colors.red.shade50
                            : order!.paymentStatus == 'paid'
                                ? Colors.green.shade50
                                : Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Status ',
                            style: ProjectConstant.WorkSansFontMediumTextStyle(
                              fontSize: 14,
                              fontColor: order!.paymentStatus == 'notpaid'
                                  ? Colors.red
                                  : order!.paymentStatus == 'paid'
                                      ? Colors.green
                                      : Colors.deepOrangeAccent,
                            ),
                          ),
                          Text(
                            '${order!.paymentStatus == 'notpaid' ? 'Not paid' : order!.paymentStatus.capitalize()}',
                            style: ProjectConstant.WorkSansFontMediumTextStyle(
                              fontSize: 13,
                              fontColor: order!.paymentStatus == 'notpaid'
                                  ? Colors.red
                                  : order!.paymentStatus == 'paid'
                                      ? Colors.green
                                      : Colors.deepOrangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (order!.orderStatus == 'accepted')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Food Preparing Time',
                                  style: ProjectConstant.WorkSansFontMediumTextStyle(
                                    fontSize: 14,
                                    fontColor: Colors.orange,
                                  ),
                                ),
                                Text(
                                  '${order!.foodPreparingTime} mins',
                                  style: ProjectConstant.WorkSansFontMediumTextStyle(
                                    fontSize: 13,
                                    fontColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              order!.foodType == 'food'
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order!.orderFoodList.length,
                      itemBuilder: (context, index) {
                        return OrderFoodWidget(
                          index: index,
                          orderFood: order!.orderFoodList[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order!.orderLiquorList.length,
                      itemBuilder: (context, index) {
                        return OrderLiquorWidget(
                          index: index,
                          orderLiquor: order!.orderLiquorList[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
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
                          'Billing Details',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
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
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 14,
                            fontColor: Colors.grey,
                          ),
                        ),
                        Text(
                          '${ProjectConstant.currencySymbol}${order!.itemTotalPrice.toStringAsFixed(2)}',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
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
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 14,
                            fontColor: Colors.grey,
                          ),
                        ),
                        Text(
                          '${ProjectConstant.currencySymbol}${order!.serviceCharge.toStringAsFixed(2)}',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
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
                          'Taxes & surcharge',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 14,
                            fontColor: Colors.grey,
                          ),
                        ),
                        Text(
                          '${ProjectConstant.currencySymbol}${(order!.taxes + order!.surcharge).toStringAsFixed(2)}',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (order!.deliveryType == 'homedelivery')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charge',
                                style: ProjectConstant.WorkSansFontMediumTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.grey,
                                ),
                              ),
                              Text(
                                '${ProjectConstant.currencySymbol}${(order!.deliveryCharge).toStringAsFixed(2)}',
                                style: ProjectConstant.WorkSansFontMediumTextStyle(
                                  fontSize: 15,
                                  fontColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    if (order!.deliveryType == 'homedelivery')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Tip',
                                style: ProjectConstant.WorkSansFontMediumTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.grey,
                                ),
                              ),
                              Text(
                                '${ProjectConstant.currencySymbol}${(order!.deliveryTip).toStringAsFixed(2)}',
                                style: ProjectConstant.WorkSansFontMediumTextStyle(
                                  fontSize: 15,
                                  fontColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coupon Discount',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 14,
                            fontColor: Colors.grey,
                          ),
                        ),
                        Text(
                          '${order!.couponDiscountAmount == 0 ? '${ProjectConstant.currencySymbol}${order!.couponDiscountAmount.toStringAsFixed(2)}' : '- ${ProjectConstant.currencySymbol}${order!.couponDiscountAmount.toStringAsFixed(2)}'}',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 15,
                            fontColor: order!.couponDiscountAmount == 0 ? Colors.black : Colors.red,
                          ),
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
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
                        ),
                        Text(
                          '${ProjectConstant.currencySymbol}${order!.grandTotal.toStringAsFixed(2)}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order!.deliveryType == 'homedelivery')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Partner Code',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 15,
                              fontColor: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            order!.deliveryPartnerCode,
                            style: ProjectConstant.WorkSansFontRegularTextStyle(
                              fontSize: 14,
                              fontColor: Colors.black,
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Type',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${order!.paymentMode == 'cod' ? 'Cash on Delivery' : order!.paymentMode.capitalize()}',
                          style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 14,
                            fontColor: Colors.black,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Type',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${order!.deliveryType == 'homedelivery' ? 'Home Delivery' : 'Pick Up'}',
                          style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 14,
                            fontColor: Colors.black,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                    if (order!.cookingInstructions != '')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cooking Instruction',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 15,
                              fontColor: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            order!.cookingInstructions,
                            style: ProjectConstant.WorkSansFontRegularTextStyle(
                              fontSize: 14,
                              fontColor: Colors.grey,
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    if (order!.deliveryInstructions != '')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Delivery Instruction',
                                style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                  fontSize: 15,
                                  fontColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                order!.deliveryInstructions,
                                style: ProjectConstant.WorkSansFontRegularTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Details',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name',
                              style: ProjectConstant.WorkSansFontMediumTextStyle(
                                fontSize: 13,
                                fontColor: Colors.black,
                              ),
                            ),
                            Text(
                              '${order!.userName}',
                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                fontSize: 12,
                                fontColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email',
                              style: ProjectConstant.WorkSansFontMediumTextStyle(
                                fontSize: 13,
                                fontColor: Colors.black,
                              ),
                            ),
                            Text(
                              '${order!.userEmail}',
                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                fontSize: 12,
                                fontColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mobile No.',
                              style: ProjectConstant.WorkSansFontMediumTextStyle(
                                fontSize: 13,
                                fontColor: Colors.black,
                              ),
                            ),
                            Text(
                              '${order!.userMobileNo}',
                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                fontSize: 12,
                                fontColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    )
                  ],
                ),
              ),
              if (order!.deliveryBoyDetails != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Partner Details',
                                style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                  fontSize: 15,
                                  fontColor: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name',
                                    style: ProjectConstant.WorkSansFontMediumTextStyle(
                                      fontSize: 13,
                                      fontColor: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${order!.deliveryBoyDetails!.name}',
                                    style: ProjectConstant.WorkSansFontRegularTextStyle(
                                      fontSize: 12,
                                      fontColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mobile No.',
                                    style: ProjectConstant.WorkSansFontMediumTextStyle(
                                      fontSize: 13,
                                      fontColor: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${order!.deliveryBoyDetails!.mobileNo}',
                                    style: ProjectConstant.WorkSansFontRegularTextStyle(
                                      fontSize: 12,
                                      fontColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Original Calculation Details',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              order!.foodType == 'food'
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order!.orderFoodList.length,
                      itemBuilder: (context, index) {
                        return OrderFoodOriginalWidget(
                          index: index,
                          orderFood: order!.orderFoodList[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order!.orderLiquorList.length,
                      itemBuilder: (context, index) {
                        return OrderLiquorOriginalWidget(
                          index: index,
                          orderLiquor: order!.orderLiquorList[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
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
                          'Billing Details',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
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
                          'Final Total',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 14,
                            fontColor: Colors.grey,
                          ),
                        ),
                        Text(
                          '${ProjectConstant.currencySymbol}${originalItemTotal.toStringAsFixed(2)}',
                          style: ProjectConstant.WorkSansFontMediumTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildPendingStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Placed',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.purple,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildAcceptedStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Food Preparing',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.blue,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildRejectedStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cancelled',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.red,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildFoodReadyStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Food Ready',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.orange,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildOnTheWayStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'On The Way',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.deepPurple,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDeliveredStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Delivered',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.green.shade700,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildNotDeliveredStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Delivery Failed',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.red.shade700,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPickedUpStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Picked Up by customer',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.green.shade700,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildNotPickedUpStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Not picked up by custome ',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.red.shade700,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCancelledStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cancelled',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.red.shade700,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildFailedStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Failed',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 14,
              fontColor: Colors.red.shade700,
            ),
          ),
          Text(
            '${DateFormat('hh:mm a').format(order!.updatedAt.toLocal())}',
            style: ProjectConstant.WorkSansFontMediumTextStyle(
              fontSize: 13,
              fontColor: Colors.red.shade700,
            ),
          ),
        ],
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
