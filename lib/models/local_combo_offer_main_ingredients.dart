import 'package:flutter/material.dart';

import 'local_combo_offer_sub_ingredients.dart';

class LocalComboOfferMainIngredients {
  String name;
  Color? color;
  List<LocalComboOfferSubIngredients> subCategoryList;

  LocalComboOfferMainIngredients({
    required this.name,
    this.color,
    required this.subCategoryList,
  });

  factory LocalComboOfferMainIngredients.fromJson(Map<String, dynamic> json) {
    return LocalComboOfferMainIngredients(
      name: json['name'],
      subCategoryList: (json['subCategoryList'] as List<dynamic>).map((e) {
        return LocalComboOfferSubIngredients.fromJson(e);
      }).toList(),
    );
  }

  static Map<String, dynamic> toJson(LocalComboOfferMainIngredients localComboOfferMainIngredients) {
    return {
      'name': localComboOfferMainIngredients.name,
      'subCategoryList': localComboOfferMainIngredients.subCategoryList.map((e) {
        return LocalComboOfferSubIngredients.toJson(e);
      }).toList(),
    };
  }
}
