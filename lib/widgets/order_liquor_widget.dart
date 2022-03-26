import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';

import '../models/order.dart';
import '../utils/project_constant.dart';

class OrderLiquorWidget extends StatefulWidget {
  final int index;
  final OrderLiquor orderLiquor;

  OrderLiquorWidget({
    required this.index,
    required this.orderLiquor,
  });

  @override
  _OrderLiquorWidgetState createState() => _OrderLiquorWidgetState();
}

class _OrderLiquorWidgetState extends State<OrderLiquorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
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
                imageUrl: '${ProjectConstant.liquor_images_path}${widget.orderLiquor.image}',
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
                        '${widget.orderLiquor.quantity} x ${widget.orderLiquor.name}',
                        style: ProjectConstant.WorkSansFontMediumTextStyle(
                          fontSize: 15,
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      '\$${widget.orderLiquor.totalPrice.toString()}',
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
                      '\$${widget.orderLiquor.basePrice.toString()}',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
    );
  }
}
