import 'package:flutter/material.dart';

class LocalExtraSubIngredients {
  String name;
  Color? color;
  double price;
  double originalPrice;

  LocalExtraSubIngredients({
    required this.name,
    this.color,
    required this.price,
    required this.originalPrice,
  });

  factory LocalExtraSubIngredients.fromJson(Map<String, dynamic> json) {
    return LocalExtraSubIngredients(
      name: json['name'],
      price: json['price'],
      originalPrice: json['originalPrice'],
    );
  }

  static Map<String, dynamic> toJson(LocalExtraSubIngredients localExtraSubIngredients) {
    return {
      'name': localExtraSubIngredients.name,
      'price': localExtraSubIngredients.price,
      'originalPrice': localExtraSubIngredients.originalPrice,
    };
  }
}
