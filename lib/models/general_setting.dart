class GeneralSetting {
  GeneralSetting({
    required this.id,
    required this.isDeliveryFree,
    required this.foodServiceChargePercent,
    required this.liquorServiceChargePercent,
    required this.airportDeliveryCharge,
    required this.railwayDeliveryCharge,
    required this.minimumOrderPrice,
    required this.taxes,
    required this.surCharge,
    required this.foodSurCharge,
    required this.liquorSurCharge,
  });

  final int id;
  final String isDeliveryFree;
  final double foodServiceChargePercent;
  final double liquorServiceChargePercent;
  final double airportDeliveryCharge;
  final double railwayDeliveryCharge;
  final double minimumOrderPrice;
  final double taxes;
  final double surCharge;
  final double foodSurCharge;
  final double liquorSurCharge;

  factory GeneralSetting.fromJson(Map<String, dynamic> json) => GeneralSetting(
    id: json["id"],
    isDeliveryFree: json["is_delivery_free"],
    foodServiceChargePercent:(json["food_service_charge_percent"] as num).toDouble(),
    liquorServiceChargePercent: (json["liquor_service_charge_percent"] as num).toDouble(),
    airportDeliveryCharge: (json["airport_delivery_charge"] as num).toDouble(),
    railwayDeliveryCharge: (json["railway_delivery_charge"] as num).toDouble(),
    minimumOrderPrice: (json["minimum_order_price"] as num).toDouble(),
    taxes: (json["taxes"] as num).toDouble(),
    surCharge: (json["surcharge"] as num).toDouble(),
    foodSurCharge: (json["food_surcharge"] as num).toDouble(),
    liquorSurCharge: (json["liquor_surcharge"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_delivery_free": isDeliveryFree,
    "food_service_charge_percent": foodServiceChargePercent,
    "liquor_service_charge_percent": liquorServiceChargePercent,
    "airport_delivery_charge": airportDeliveryCharge,
    "railway_delivery_charge": railwayDeliveryCharge,
    "minimum_order_price": minimumOrderPrice,
    "taxes": taxes,
    "surcharge": surCharge,
    "food_surcharge": foodSurCharge,
    "liquor_surcharge": liquorSurCharge,
  };
}
