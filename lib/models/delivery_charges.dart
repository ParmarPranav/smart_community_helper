class DeliveryCharges {
  DeliveryCharges({
    required this.id,
    required this.registerCityId,
    required this.from,
    required this.to,
    required this.charge,
    required this.status,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int registerCityId;
  final int from;
  final int to;
  final int charge;
  final String status;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DeliveryCharges.fromJson(Map<String, dynamic> json) => DeliveryCharges(
    id: json["id"],
    registerCityId: json["register_city_id"],
    from: json["from"],
    to: json["to"],
    charge: json["charge"],
    status: json["status"],
    city: json["city"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "register_city_id": registerCityId,
    "from": from,
    "to": to,
    "charge": charge,
    "status": status,
    "city": city,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
