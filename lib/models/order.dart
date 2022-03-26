import 'package:intl/intl.dart';

class Order {
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
    required this.serviceCharge,
    required this.taxes,
    required this.surcharge,
    required this.couponCode,
    required this.couponDiscountAmount,
    required this.deliveryCharge,
    required this.deliveryTip,
    required this.grandTotal,
    required this.paymentMode,
    required this.paymentType,
    required this.foodPreparingTime,
    required this.cookingInstructions,
    required this.deliveryInstructions,
    required this.deliveryPartnerCode,
    required this.deliveryFailedNote,
    required this.createdAt,
    required this.updatedAt,
    required this.orderFoodList,
    required this.orderLiquorList,
    required this.deliveryBoyDetails,
  });

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
  final double serviceCharge;
  final double taxes;
  final double surcharge;
  final String couponCode;
  final double couponDiscountAmount;
  final double deliveryCharge;
  final double deliveryTip;
  final double grandTotal;
  final String paymentMode;
  final String paymentType;
  final String foodPreparingTime;
  final String cookingInstructions;
  final String deliveryInstructions;
  final String deliveryPartnerCode;
  final String deliveryFailedNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderFood> orderFoodList;
  final List<OrderLiquor> orderLiquorList;
  final DeliveryBoyDetails? deliveryBoyDetails;

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
        serviceCharge: (json["service_charge"] as num).toDouble(),
        taxes: (json["taxes"] as num).toDouble(),
        surcharge: (json["surcharge"] as num).toDouble(),
        couponCode: json["coupon_code"],
        couponDiscountAmount: (json["coupon_discount_amount"] as num).toDouble(),
        deliveryCharge: (json["delivery_charge"] as num).toDouble(),
        deliveryTip: (json["delivery_tip"] as num).toDouble(),
        grandTotal: (json["grand_total"] as num).toDouble(),
        paymentMode: json["payment_mode"],
        paymentType: json["payment_type"],
        foodPreparingTime: json["food_preparing_time"],
        cookingInstructions: json["cooking_instructions"],
        deliveryInstructions: json["delivery_instructions"],
        deliveryPartnerCode: json["delivery_partner_code"],
        deliveryFailedNote: json["delivery_failed_note"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        orderFoodList: json.containsKey("order_food_list") ? List<OrderFood>.from(json["order_food_list"].map((x) => OrderFood.fromJson(x))) : [],
        orderLiquorList: json.containsKey("order_liquor_list") ? List<OrderLiquor>.from(json["order_liquor_list"].map((x) => OrderLiquor.fromJson(x))) : [],
        deliveryBoyDetails: json["delivery_boy_details"] != null ? DeliveryBoyDetails.fromJson(json["delivery_boy_details"]) : null,
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
        "service_charge": serviceCharge,
        "taxes": taxes,
        "surcharge": surcharge,
        "coupon_code": couponCode,
        "coupon_discount_amount": couponDiscountAmount,
        "delivery_charge": deliveryCharge,
        "delivery_tip": deliveryTip,
        "grand_total": grandTotal,
        "payment_mode": paymentMode,
        "payment_type": paymentType,
        "food_preparing_time": foodPreparingTime,
        "cooking_instructions": cookingInstructions,
        "delivery_instructions": deliveryInstructions,
        "delivery_partner_code": deliveryPartnerCode,
        "delivery_failed_note": deliveryFailedNote,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "order_food_list": List<dynamic>.from(orderFoodList.map((x) => x.toJson())),
        "order_liquor_list": List<dynamic>.from(orderLiquorList.map((x) => x.toJson())),
        "delivery_boy_details": deliveryBoyDetails!.toJson(),
      };
}

class DeliveryBoyDetails {
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
    required this.currentOrderNo,
    required this.createdAt,
    required this.updatedAt,
  });

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
  final String currentOrderNo;
  final DateTime createdAt;
  final DateTime updatedAt;

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
        currentOrderNo: json["current_order_no"],
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
        "current_order_no": currentOrderNo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class OrderFood {
  final int id;
  final String orderNo;
  final int foodId;
  final String name;
  final String image;
  final double basePrice;
  final double originalPrice;
  final double finalPrice;
  final int quantity;
  final double totalPrice;
  final String removableIngredients;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FoodOrderComboOfferIngredients> orderComboOfferIngredientsList;
  final List<FoodOrderExtraIngredients> orderExtraIngredientsList;

  OrderFood({
    required this.id,
    required this.orderNo,
    required this.foodId,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.originalPrice,
    required this.finalPrice,
    required this.quantity,
    required this.totalPrice,
    required this.removableIngredients,
    required this.createdAt,
    required this.updatedAt,
    required this.orderComboOfferIngredientsList,
    required this.orderExtraIngredientsList,
  });

  factory OrderFood.fromJson(Map<String, dynamic> json) => OrderFood(
        id: json["id"],
        orderNo: json["order_no"],
        foodId: json["food_id"],
        name: json["name"],
        image: json["image"],
        basePrice: (json["base_price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
        finalPrice: (json["final_price"] as num).toDouble(),
        quantity: json["quantity"],
        totalPrice: (json["total_price"] as num).toDouble(),
        removableIngredients: json["removable_ingredients"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        orderComboOfferIngredientsList: json.containsKey('order_combo_offer_ingredients_list')
            ? List<FoodOrderComboOfferIngredients>.from(json["order_combo_offer_ingredients_list"].map((x) => FoodOrderComboOfferIngredients.fromJson(x)))
            : [],
        orderExtraIngredientsList:
            json.containsKey('order_extra_ingredients_list') ? List<FoodOrderExtraIngredients>.from(json["order_extra_ingredients_list"].map((x) => FoodOrderExtraIngredients.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "food_id": foodId,
        "name": name,
        "image": image,
        "base_price": basePrice,
        "original_price": originalPrice,
        "final_price": finalPrice,
        "quantity": quantity,
        "total_price": totalPrice,
        "removable_ingredients": removableIngredients,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "order_combo_offer_ingredients_list": List<dynamic>.from(orderComboOfferIngredientsList.map((x) => x.toJson())),
        "order_extra_ingredients_list": List<dynamic>.from(orderExtraIngredientsList.map((x) => x.toJson())),
      };
}

class FoodOrderComboOfferIngredients {
  final int id;
  final int orderFoodId;
  final String name;
  final double price;
  final double originalPrice;
  final String isFree;

  FoodOrderComboOfferIngredients({
    required this.id,
    required this.orderFoodId,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.isFree,
  });

  factory FoodOrderComboOfferIngredients.fromJson(Map<String, dynamic> json) => FoodOrderComboOfferIngredients(
        id: json["id"],
        orderFoodId: json["order_food_id"],
        name: json["name"],
        price: (json["price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
        isFree: json["is_free"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_food_id": orderFoodId,
        "name": name,
        "price": price,
        "original_price": originalPrice,
        "is_free": isFree,
      };
}

class FoodOrderExtraIngredients {
  final int id;
  final int orderFoodId;
  final String name;
  final double price;
  final double originalPrice;

  FoodOrderExtraIngredients({
    required this.id,
    required this.orderFoodId,
    required this.name,
    required this.price,
    required this.originalPrice,
  });

  factory FoodOrderExtraIngredients.fromJson(Map<String, dynamic> json) => FoodOrderExtraIngredients(
        id: json["id"],
        orderFoodId: json["order_food_id"],
        name: json["name"],
        price: (json["price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_food_id": orderFoodId,
        "name": name,
        "price": price,
        "original_price": originalPrice,
      };
}

class OrderLiquor {
  OrderLiquor({
    required this.id,
    required this.orderNo,
    required this.liquorId,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.originalPrice,
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
  final double originalPrice;
  final double finalPrice;
  final int quantity;
  final double totalPrice;

  final DateTime createdAt;
  final DateTime updatedAt;

  factory OrderLiquor.fromJson(Map<String, dynamic> json) => OrderLiquor(
        id: json["id"],
        orderNo: json["order_no"],
        liquorId: json["liquor_id"],
        name: json["name"],
        image: json["image"],
        basePrice: (json["base_price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
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
        "original_price": originalPrice,
        "final_price": finalPrice,
        "quantity": quantity,
        "total_price": totalPrice,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
