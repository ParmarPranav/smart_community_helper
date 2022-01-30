import 'package:intl/intl.dart';

class FoodItem {
  final int id;
  final String restaurantId;
  final int foodCategoryId;
  final String name;
  final String foodType;
  final double price;
  final String description;
  final String image;
  final String inStock;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String foodCategoryName;
  final List<ChoosableIngredientsMainCategory> choosableIngredientsMainCategoryList;
  final List<ExtraIngredientsMainCategory> extraIngredientsMainCategoryList;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.foodCategoryId,
    required this.name,
    required this.foodType,
    required this.price,
    required this.description,
    required this.image,
    required this.inStock,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.foodCategoryName,
    required this.choosableIngredientsMainCategoryList,
    required this.extraIngredientsMainCategoryList,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        foodCategoryId: json["food_category_id"],
        name: json["name"],
        foodType: json["food_type"],
        price: (json["price"] as num).toDouble(),
        description: json["description"],
        image: json["image"],
        inStock: json["in_stock"],
        type: json["type"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        foodCategoryName: json["food_category_name"],
        choosableIngredientsMainCategoryList: List<ChoosableIngredientsMainCategory>.from(json["choosable_ingredients_main_category_list"].map((x) => ChoosableIngredientsMainCategory.fromJson(x))),
        extraIngredientsMainCategoryList: List<ExtraIngredientsMainCategory>.from(json["extra_food_main_category_list"].map((x) => ExtraIngredientsMainCategory.fromJson(x))),
      );
}

class ChoosableIngredientsMainCategory {
  final int id;
  final int foodId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChoosableIngredientsSubCategory> choosableIngredientsSubCategoryList;

  ChoosableIngredientsMainCategory({
    required this.id,
    required this.foodId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.choosableIngredientsSubCategoryList,
  });

  factory ChoosableIngredientsMainCategory.fromJson(Map<String, dynamic> json) => ChoosableIngredientsMainCategory(
        id: json["id"],
        foodId: json["food_id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        choosableIngredientsSubCategoryList: List<ChoosableIngredientsSubCategory>.from(json["choosable_ingredients_sub_category_list"].map((x) => ChoosableIngredientsSubCategory.fromJson(x))),
      );
}

class ChoosableIngredientsSubCategory {
  final int id;
  final int mainCategoryId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChoosableIngredientsSubCategory({
    required this.id,
    required this.mainCategoryId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChoosableIngredientsSubCategory.fromJson(Map<String, dynamic> json) => ChoosableIngredientsSubCategory(
        id: json["id"],
        mainCategoryId: json["main_category_id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );
}

class ExtraIngredientsMainCategory {
  final int id;
  final int foodId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ExtraIngredientsSubCategory> extraIngredientsSubCategoryList;

  ExtraIngredientsMainCategory({
    required this.id,
    required this.foodId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.extraIngredientsSubCategoryList,
  });

  factory ExtraIngredientsMainCategory.fromJson(Map<String, dynamic> json) => ExtraIngredientsMainCategory(
        id: json["id"],
        foodId: json["food_id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        extraIngredientsSubCategoryList: List<ExtraIngredientsSubCategory>.from(json["extra_food_sub_category_list"].map((x) => ExtraIngredientsSubCategory.fromJson(x))),
      );
}

class ExtraIngredientsSubCategory {
  final int id;
  final int mainCategoryId;
  final String name;
  final double price;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExtraIngredientsSubCategory({
    required this.id,
    required this.mainCategoryId,
    required this.name,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExtraIngredientsSubCategory.fromJson(Map<String, dynamic> json) => ExtraIngredientsSubCategory(
        id: json["id"],
        mainCategoryId: json["main_category_id"],
        name: json["name"],
        price: (json["price"] as num).toDouble(),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
