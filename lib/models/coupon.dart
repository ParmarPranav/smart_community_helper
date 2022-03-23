import 'package:intl/intl.dart';

class Coupon {
  final int id;
  final String couponCode;
  final String couponTitle;
  final String couponSubtitle;
  final DateTime validityEnd;
  final String discountCalculationType;
  final String discountType;
  final double discountValue;
  final double minimumOrderPrice;
  final double maximumDiscountPrice;
  final int noOfTimeUse;
  final String userType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Coupon({
    required this.id,
    required this.couponCode,
    required this.couponTitle,
    required this.couponSubtitle,
    required this.validityEnd,
    required this.discountCalculationType,
    required this.discountType,
    required this.discountValue,
    required this.minimumOrderPrice,
    required this.maximumDiscountPrice,
    required this.noOfTimeUse,
    required this.userType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        couponCode: json["coupon_code"],
        couponTitle: json["coupon_title"],
        couponSubtitle: json["coupon_subtitle"],
        validityEnd: DateTime.parse(json["validity_end"]),
        discountCalculationType: json["discount_calculation_type"],
        discountType: json["discount_type"],
        discountValue: (json["discount_value"] as num).toDouble(),
        minimumOrderPrice: (json["minimum_order_price"] as num).toDouble(),
        maximumDiscountPrice: (json["maximum_discount_price"] as num).toDouble(),
        noOfTimeUse: json["no_of_time_use"],
        userType: json["user_type"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_code": couponCode,
        "coupon_title": couponTitle,
        "coupon_subtitle": couponSubtitle,
        "validity_end": validityEnd.toIso8601String(),
        "discount_calculation_type": discountCalculationType,
        "discount_type": discountType,
        "discount_value": discountValue,
        "minimum_order_price": minimumOrderPrice,
        "maximum_discount_price": maximumDiscountPrice,
        "no_of_time_use": noOfTimeUse,
        "user_type": userType,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
