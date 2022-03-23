import 'package:intl/intl.dart';

class LiquorItem {
  final int id;
  final String restaurantId;
  final int liquorCategoryId;
  final String name;
  final double price;
  final double orginalPrice;
  final String description;
  final String image;
  final String inStock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String liquorCategoryName;

  LiquorItem({
    required this.id,
    required this.restaurantId,
    required this.liquorCategoryId,
    required this.name,
    required this.price,
    required this.orginalPrice,
    required this.description,
    required this.image,
    required this.inStock,
    required this.createdAt,
    required this.updatedAt,
    required this.liquorCategoryName,
  });

  factory LiquorItem.fromJson(Map<String, dynamic> json) => LiquorItem(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        liquorCategoryId: json["liquor_category_id"],
        name: json["name"],
        price: (json["price"] as num).toDouble(),
        orginalPrice: (json["original_price"] as num).toDouble(),
        description: json["description"],
        image: json["image"],
        inStock: json["in_stock"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        liquorCategoryName: json["liquor_category_name"],
      );
}
