import 'package:intl/intl.dart';

class Order {
  final int id;
  final String orderNo;
  final String restaurantId;
  final String userId;
  final String deliveryBoyId;
  final String foodType;
  final String userName;
  final String userEmail;
  final String userMobileNo;
  final String completeAddress;
  final String nearByLandmark;
  final String floor;
  final String deliveryLocationType;
  final String currentLocation;
  final String latitude;
  final String longitude;
  final String deliveryType;
  final String orderStatus;
  final String paymentStatus;
  final double itemTotalPrice;
  final double taxes;
  final double surcharge;
  final double serviceCharge;
  final String couponCode;
  final double couponDiscountAmount;
  final double deliveryCharge;
  final double grandTotal;
  final double deliveryTip;
  final String paymentMode;
  final String paymentType;
  final String foodPreparingTime;
  final String deliveryInstructions;
  final String cookingInstructions;
  final String deliveryPartnerCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FoodOrder> foodOrderList;
  final List<LiquorOrder> liquorOrderList;

  Order({
    required this.id,
    required this.orderNo,
    required this.restaurantId,
    required this.userId,
    required this.deliveryBoyId,
    required this.foodType,
    required this.userName,
    required this.userEmail,
    required this.userMobileNo,
    required this.completeAddress,
    required this.nearByLandmark,
    required this.floor,
    required this.deliveryLocationType,
    required this.currentLocation,
    required this.latitude,
    required this.longitude,
    required this.deliveryType,
    required this.orderStatus,
    required this.paymentStatus,
    required this.itemTotalPrice,
    required this.taxes,
    required this.surcharge,
    required this.serviceCharge,
    required this.couponCode,
    required this.couponDiscountAmount,
    required this.deliveryCharge,
    required this.grandTotal,
    required this.deliveryTip,
    required this.paymentMode,
    required this.paymentType,
    required this.foodPreparingTime,
    required this.deliveryInstructions,
    required this.cookingInstructions,
    required this.deliveryPartnerCode,
    required this.createdAt,
    required this.updatedAt,
    required this.foodOrderList,
    required this.liquorOrderList,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderNo: json["order_no"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        deliveryBoyId: json["delivery_boy_id"],
        foodType: json["food_type"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userMobileNo: json["user_mobile_no"],
        completeAddress: json["complete_address"],
        nearByLandmark: json["near_by_landmark"],
        floor: json["floor"],
        deliveryLocationType: json["delivery_location_type"],
        currentLocation: json["current_location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        deliveryType: json["delivery_type"],
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        itemTotalPrice: (json["item_total_price"] as num).toDouble(),
        taxes: (json["taxes"] as num).toDouble(),
        surcharge: (json["surcharge"] as num).toDouble(),
        serviceCharge: (json["service_charge"] as num).toDouble(),
        couponCode: json["coupon_code"],
        couponDiscountAmount: (json["coupon_discount_amount"] as num).toDouble(),
        deliveryCharge: (json["delivery_charge"] as num).toDouble(),
        grandTotal: (json["grand_total"] as num).toDouble(),
        deliveryTip: (json["delivery_tip"] as num).toDouble(),
        paymentMode: json["payment_mode"],
        paymentType: json["payment_type"],
        foodPreparingTime: json["food_preparing_time"],
        deliveryInstructions: json["delivery_instructions"],
        cookingInstructions: json["cooking_instructions"],
        deliveryPartnerCode: json["delivery_partner_code"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        foodOrderList: json.containsKey('order_food_list') ? List<FoodOrder>.from(json["order_food_list"].map((x) => FoodOrder.fromJson(x))) : [],
        liquorOrderList: json.containsKey('order_liquor_list') ? List<LiquorOrder>.from(json["order_liquor_list"].map((x) => LiquorOrder.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "restaurant_id": restaurantId,
        "user_id": userId,
        "delivery_boy_id": deliveryBoyId,
        "food_type": foodType,
        "user_name": userName,
        "user_email": userEmail,
        "user_mobile_no": userMobileNo,
        "complete_address": completeAddress,
        "near_by_landmark": nearByLandmark,
        "floor": floor,
        "delivery_location_type": deliveryLocationType,
        "current_location": currentLocation,
        "latitude": latitude,
        "longitude": longitude,
        "delivery_type": deliveryType,
        "order_status": orderStatus,
        "payment_status": paymentStatus,
        "item_total_price": itemTotalPrice,
        "taxes": taxes,
        "surcharge": surcharge,
        "service_charge": serviceCharge,
        "coupon_code": couponCode,
        "coupon_discount_amount": couponDiscountAmount,
        "delivery_charge": deliveryCharge,
        "grand_total": grandTotal,
        "delivery_tip": deliveryTip,
        "payment_mode": paymentMode,
        "payment_type": paymentType,
        "food_preparing_time": foodPreparingTime,
        "delivery_instruction": deliveryInstructions,
        "cooking_instruction": cookingInstructions,
        "delivery_partner_code": deliveryPartnerCode,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "order_food_list": List<dynamic>.from(foodOrderList.map((x) => x.toJson())),
      };
}

class FoodOrder {
  FoodOrder({
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
  final double basePrice;
  final double finalPrice;
  final int quantity;
  final double totalPrice;
  final String choosableIngredients;
  final String extraIngredients;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory FoodOrder.fromJson(Map<String, dynamic> json) => FoodOrder(
        id: json["id"],
        orderNo: json["order_no"],
        foodId: json["food_id"],
        name: json["name"],
        image: json["image"],
        basePrice: (json["base_price"] as num).toDouble(),
        finalPrice: (json["final_price"] as num).toDouble(),
        quantity: json["quantity"],
        totalPrice: (json["total_price"] as num).toDouble(),
        choosableIngredients: json["choosable_ingredients"],
        extraIngredients: json["extra_ingredients"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
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

class LiquorOrder {
  LiquorOrder({
    required this.id,
    required this.orderNo,
    required this.liquorId,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.finalPrice,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String orderNo;
  final int liquorId;
  final String name;
  final String image;
  final double basePrice;
  final double finalPrice;
  final int quantity;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory LiquorOrder.fromJson(Map<String, dynamic> json) => LiquorOrder(
        id: json["id"],
        orderNo: json["order_no"],
        liquorId: json["liquor_id"],
        name: json["name"],
        image: json["image"],
        basePrice: (json["base_price"] as num).toDouble(),
        finalPrice: (json["final_price"] as num).toDouble(),
        quantity: json["quantity"],
        totalPrice: (json["total_price"] as num).toDouble(),
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "liquor_id": liquorId,
        "name": name,
        "image": image,
        "base_price": basePrice,
        "final_price": finalPrice,
        "quantity": quantity,
        "total_price": totalPrice,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class DeliveryBoyDetails {
  final int id;
  final int registerCityId;
  final String name;
  final String mobileNo;
  final String email;
  final String deliveryType;
  final String address;
  final String city;
  final String state;
  final String country;
  final String currentLocation;
  final String latitude;
  final String longitude;
  final String heading;
  final String isVerify;
  final int noOfOrders;
  final String isAvailable;
  final String isOrderAssigned;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryBoyDetails({
    required this.id,
    required this.registerCityId,
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.deliveryType,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.currentLocation,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.isVerify,
    required this.noOfOrders,
    required this.isAvailable,
    required this.isOrderAssigned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryBoyDetails.fromJson(Map<String, dynamic> json) => DeliveryBoyDetails(
        id: json["id"],
        registerCityId: json["register_city_id"],
        name: json["name"],
        mobileNo: json["mobile_no"],
        email: json["email"],
        deliveryType: json["delivery_type"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        currentLocation: json["current_location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        heading: json["heading"],
        isVerify: json["is_verify"],
        noOfOrders: json["no_of_orders"],
        isAvailable: json["is_available"],
        isOrderAssigned: json["is_order_assigned"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "register_city_id": registerCityId,
        "name": name,
        "mobile_no": mobileNo,
        "email": email,
        "delivery_type": deliveryType,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "current_location": currentLocation,
        "latitude": latitude,
        "longitude": longitude,
        "heading": heading,
        "is_verify": isVerify,
        "no_of_orders": noOfOrders,
        "is_available": isAvailable,
        "is_order_assigned": isOrderAssigned,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
