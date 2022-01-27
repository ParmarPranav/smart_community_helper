import 'package:intl/intl.dart';

class FoodItem {
  final int id;
  final String restaurantId;
  final int foodCategoryId;
  final String name;
  final String foodType;
  final double price;
  final String description;
  final String inStock;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String foodCategoryName;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.foodCategoryId,
    required this.name,
    required this.foodType,
    required this.price,
    required this.description,
    required this.inStock,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.foodCategoryName,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        foodCategoryId: json["food_category_id"],
        name: json["name"],
        foodType: json["food_type"],
        price: (json["price"] as num).toDouble(),
        description: json["description"],
        inStock: json["in_stock"],
        type: json["type"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        foodCategoryName: json["food_category_name"],
      );
}
