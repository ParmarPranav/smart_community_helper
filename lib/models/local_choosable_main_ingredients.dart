import 'package:food_hunt_admin_app/models/local_choosable_sub_ingredients.dart';

class LocalChoosableMainIngredients {
  String name;
  List<LocalChoosableSubIngredients> subCategoryList;

  LocalChoosableMainIngredients({
    required this.name,
    required this.subCategoryList,
  });

  factory LocalChoosableMainIngredients.fromJson(Map<String, dynamic> json) {
    return LocalChoosableMainIngredients(
      name: json['name'],
      subCategoryList: (json['subCategoryList'] as List<dynamic>).map((e) {
        return LocalChoosableSubIngredients.fromJson(e);
      }).toList(),
    );
  }

  static Map<String, dynamic> toJson(LocalChoosableMainIngredients localChoosableMainIngredients) {
    return {
      'name': localChoosableMainIngredients.name,
      'subCategoryList': localChoosableMainIngredients.subCategoryList.map((e) {
        return {
          'name': e.name,
        };
      }).toList(),
    };
  }
}
