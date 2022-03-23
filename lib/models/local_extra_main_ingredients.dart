import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/local_extra_sub_ingredients.dart';

class LocalExtraMainIngredients {
  String name;
  Color? color;
  List<LocalExtraSubIngredients> subCategoryList;

  LocalExtraMainIngredients({
    required this.name,
    this.color,
    required this.subCategoryList,
  });

  factory LocalExtraMainIngredients.fromJson(Map<String, dynamic> json) {
    return LocalExtraMainIngredients(
      name: json['name'],
      subCategoryList: (json['subCategoryList'] as List<dynamic>).map((e) {
        return LocalExtraSubIngredients.fromJson(e);
      }).toList(),
    );
  }

  static Map<String, dynamic> toJson(LocalExtraMainIngredients localExtraMainIngredients) {
    return {
      'name': localExtraMainIngredients.name,
      'subCategoryList': localExtraMainIngredients.subCategoryList.map((e) {
        return LocalExtraSubIngredients.toJson(e);
      }).toList(),
    };
  }
}
