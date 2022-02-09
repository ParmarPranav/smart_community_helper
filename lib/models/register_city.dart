class RegisterCity {
  RegisterCity({
    required this.id,
    required this.city,
    required this.state,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String city;
  final String state;
  final String country;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory RegisterCity.fromJson(Map<String, dynamic> json) => RegisterCity(
    id: json["id"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city": city,
    "state": state,
    "country": country,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
