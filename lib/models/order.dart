class Order {
  Order({
    required this.id,
    required this.orderNo,
    required this.restaurantId,
    required this.userId,
    required this.deliveryBoyId,
    required this.foodType,
    required this.completeAddress,
    required this.deliveryLocationType,
    required this.currentLocation,
    required this.latitude,
    required this.longitude,
    required this.deliveryType,
    required this.orderStatus,
    required this.paymentStatus,
    required this.itemTotalPrice,
    required this.taxAmount,
    required this.serviceCharge,
    required this.couponCode,
    required this.couponDiscountAmount,
    required this.deliveryCharge,
    required this.grandTotal,
    required this.deliveryTip,
    required this.paymentMode,
    required this.paymentType,
    required this.foodPreparingTime,
    required this.deliveryInstruction,
    required this.createdAt,
    required this.updatedAt,
    required this.orderFoodList,
  });

  final int id;
  final String orderNo;
  final String restaurantId;
  final String userId;
  final int deliveryBoyId;
  final String foodType;
  final String completeAddress;
  final String deliveryLocationType;
  final String currentLocation;
  final String latitude;
  final String longitude;
  final String deliveryType;
  final String orderStatus;
  final String paymentStatus;
  final int itemTotalPrice;
  final int taxAmount;
  final int serviceCharge;
  final String couponCode;
  final int couponDiscountAmount;
  final int deliveryCharge;
  final int grandTotal;
  final int deliveryTip;
  final String paymentMode;
  final String paymentType;
  final String foodPreparingTime;
  final String deliveryInstruction;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderFoodList> orderFoodList;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    orderNo: json["order_no"],
    restaurantId: json["restaurant_id"],
    userId: json["user_id"],
    deliveryBoyId: json["delivery_boy_id"],
    foodType: json["food_type"],
    completeAddress: json["complete_address"],
    deliveryLocationType: json["delivery_location_type"],
    currentLocation: json["current_location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    deliveryType: json["delivery_type"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    itemTotalPrice: json["item_total_price"],
    taxAmount: json["tax_amount"],
    serviceCharge: json["service_charge"],
    couponCode: json["coupon_code"],
    couponDiscountAmount: json["coupon_discount_amount"],
    deliveryCharge: json["delivery_charge"],
    grandTotal: json["grand_total"],
    deliveryTip: json["delivery_tip"],
    paymentMode: json["payment_mode"],
    paymentType: json["payment_type"],
    foodPreparingTime: json["food_preparing_time"],
    deliveryInstruction: json["delivery_instruction"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    orderFoodList: List<OrderFoodList>.from(json["order_food_list"].map((x) => OrderFoodList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_no": orderNo,
    "restaurant_id": restaurantId,
    "user_id": userId,
    "delivery_boy_id": deliveryBoyId,
    "food_type": foodType,
    "complete_address": completeAddress,
    "delivery_location_type": deliveryLocationType,
    "current_location": currentLocation,
    "latitude": latitude,
    "longitude": longitude,
    "delivery_type": deliveryType,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "item_total_price": itemTotalPrice,
    "tax_amount": taxAmount,
    "service_charge": serviceCharge,
    "coupon_code": couponCode,
    "coupon_discount_amount": couponDiscountAmount,
    "delivery_charge": deliveryCharge,
    "grand_total": grandTotal,
    "delivery_tip": deliveryTip,
    "payment_mode": paymentMode,
    "payment_type": paymentType,
    "food_preparing_time": foodPreparingTime,
    "delivery_instruction": deliveryInstruction,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "order_food_list": List<dynamic>.from(orderFoodList.map((x) => x.toJson())),
  };
}

class OrderFoodList {
  OrderFoodList({
    required this.id,
    required this.orderNo,
    required this.foodId,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.finalPrice,
    required this.quantity,
    required this.totalPrice,
    required this.choosableIngredients,
    required this.extraIngredients,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String orderNo;
  final int foodId;
  final String name;
  final String image;
  final int basePrice;
  final int finalPrice;
  final int quantity;
  final int totalPrice;
  final String choosableIngredients;
  final String extraIngredients;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory OrderFoodList.fromJson(Map<String, dynamic> json) => OrderFoodList(
    id: json["id"],
    orderNo: json["order_no"],
    foodId: json["food_id"],
    name: json["name"],
    image: json["image"],
    basePrice: json["base_price"],
    finalPrice: json["final_price"],
    quantity: json["quantity"],
    totalPrice: json["total_price"],
    choosableIngredients: json["choosable_ingredients"],
    extraIngredients: json["extra_ingredients"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_no": orderNo,
    "food_id": foodId,
    "name": name,
    "image": image,
    "base_price": basePrice,
    "final_price": finalPrice,
    "quantity": quantity,
    "total_price": totalPrice,
    "choosable_ingredients": choosableIngredients,
    "extra_ingredients": extraIngredients,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
