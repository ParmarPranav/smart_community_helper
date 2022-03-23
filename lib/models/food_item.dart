import 'package:intl/intl.dart';

class FoodItem {
  final int id;
  final String restaurantId;
  final int foodCategoryId;
  final String name;
  final String foodType;
  final double price;
  final double originalPrice;
  final String description;
  final String image;
  final String inStock;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String foodCategoryName;
  final List<RemovableIngredients> removableIngredientsList;
  final List<ExtraIngredientsMainCategory> extraIngredientsMainCategoryList;
  final List<ComboOfferIngredientsMainCategory> comboOfferIngredientsMainCategoryList;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.foodCategoryId,
    required this.name,
    required this.foodType,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.image,
    required this.inStock,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.foodCategoryName,
    required this.removableIngredientsList,
    required this.extraIngredientsMainCategoryList,
    required this.comboOfferIngredientsMainCategoryList,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        foodCategoryId: json["food_category_id"],
        name: json["name"],
        foodType: json["food_type"],
        price: (json["price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
        description: json["description"],
        image: json["image"],
        inStock: json["in_stock"],
        type: json["type"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        foodCategoryName: json["food_category_name"],
        removableIngredientsList: json.containsKey('removable_ingredients_list') ? List<RemovableIngredients>.from(json["removable_ingredients_list"].map((x) => RemovableIngredients.fromJson(x))) : [],
        extraIngredientsMainCategoryList: json.containsKey('extra_food_main_category_list') ? List<ExtraIngredientsMainCategory>.from(json["extra_food_main_category_list"].map((x) => ExtraIngredientsMainCategory.fromJson(x))) : [],
        comboOfferIngredientsMainCategoryList:
            json.containsKey('combo_offer_ingredients_main_category_list') ? List<ComboOfferIngredientsMainCategory>.from(json["combo_offer_ingredients_main_category_list"].map((x) => ComboOfferIngredientsMainCategory.fromJson(x))) : [],
      );
}

class RemovableIngredients {
  final int id;
  final int foodId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RemovableIngredients({
    required this.id,
    required this.foodId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RemovableIngredients.fromJson(Map<String, dynamic> json) => RemovableIngredients(
        id: json["id"],
        foodId: json["food_id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );
}

class ComboOfferIngredientsMainCategory {
  final int id;
  final int foodId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ComboOfferIngredientsSubCategory> comboOfferIngredientsSubCategoryList;

  ComboOfferIngredientsMainCategory({
    required this.id,
    required this.foodId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.comboOfferIngredientsSubCategoryList,
  });

  factory ComboOfferIngredientsMainCategory.fromJson(Map<String, dynamic> json) => ComboOfferIngredientsMainCategory(
        id: json["id"],
        foodId: json["food_id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        comboOfferIngredientsSubCategoryList: List<ComboOfferIngredientsSubCategory>.from(json["combo_offer_ingredients_sub_category_list"].map((x) => ComboOfferIngredientsSubCategory.fromJson(x))),
      );
}

class ComboOfferIngredientsSubCategory {
  final int id;
  final int mainCategoryId;
  final String name;
  final String status;
  final double price;
  final double originalPrice;
  final String isFree;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComboOfferIngredientsSubCategory({
    required this.id,
    required this.mainCategoryId,
    required this.name,
    required this.status,
    required this.price,
    required this.originalPrice,
    required this.isFree,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComboOfferIngredientsSubCategory.fromJson(Map<String, dynamic> json) => ComboOfferIngredientsSubCategory(
        id: json["id"],
        mainCategoryId: json["main_category_id"],
        name: json["name"],
        status: json["status"],
        price: (json["price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
        isFree: json["is_free"],
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
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        extraIngredientsSubCategoryList: List<ExtraIngredientsSubCategory>.from(json["extra_food_sub_category_list"].map((x) => ExtraIngredientsSubCategory.fromJson(x))),
      );
}

class ExtraIngredientsSubCategory {
  final int id;
  final int mainCategoryId;
  final String name;
  final double price;
  final double originalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExtraIngredientsSubCategory({
    required this.id,
    required this.mainCategoryId,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExtraIngredientsSubCategory.fromJson(Map<String, dynamic> json) => ExtraIngredientsSubCategory(
        id: json["id"],
        mainCategoryId: json["main_category_id"],
        name: json["name"],
        price: (json["price"] as num).toDouble(),
        originalPrice: (json["original_price"] as num).toDouble(),
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );
}
