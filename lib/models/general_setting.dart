class GeneralSetting {
  GeneralSetting({
    required this.id,
    required this.isDeliveryFree,
    required this.foodServiceChargePercent,
    required this.liquorServiceChargePercent,
    required this.airportDeliveryCharge,
    required this.railwayDeliveryCharge,
  });

  final int id;
  final String isDeliveryFree;
  final int foodServiceChargePercent;
  final int liquorServiceChargePercent;
  final int airportDeliveryCharge;
  final int railwayDeliveryCharge;

  factory GeneralSetting.fromJson(Map<String, dynamic> json) => GeneralSetting(
    id: json["id"],
    isDeliveryFree: json["is_delivery_free"],
    foodServiceChargePercent: json["food_service_charge_percent"],
    liquorServiceChargePercent: json["liquor_service_charge_percent"],
    airportDeliveryCharge: json["airport_delivery_charge"],
    railwayDeliveryCharge: json["railway_delivery_charge"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_delivery_free": isDeliveryFree,
    "food_service_charge_percent": foodServiceChargePercent,
    "liquor_service_charge_percent": liquorServiceChargePercent,
    "airport_delivery_charge": airportDeliveryCharge,
    "railway_delivery_charge": railwayDeliveryCharge,
  };
}
