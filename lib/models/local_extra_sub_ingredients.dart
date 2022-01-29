import 'package:flutter/material.dart';

class LocalExtraSubIngredients {
  String name;
  Color? color;
  double price;

  LocalExtraSubIngredients({
    required this.name,
    this.color,
    required this.price,
  });

  factory LocalExtraSubIngredients.fromJson(Map<String, dynamic> json) {
    return LocalExtraSubIngredients(name: json['name'], price: json['price']);
  }

  static Map<String, dynamic> toJson(LocalExtraSubIngredients localExtraSubIngredients) {
    return {
      'name': localExtraSubIngredients.name,
      'price': localExtraSubIngredients.price,
    };
  }
}
