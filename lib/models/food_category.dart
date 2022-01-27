import 'package:intl/intl.dart';

class FoodCategory {
  FoodCategory({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String restaurantId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory FoodCategory.fromJson(Map<String, dynamic> json) => FoodCategory(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "restaurant_id": restaurantId,
        "name": name,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
