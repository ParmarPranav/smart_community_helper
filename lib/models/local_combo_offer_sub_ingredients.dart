import 'package:flutter/material.dart';

class LocalComboOfferSubIngredients {
  String name;
  Color? color;
  double price;
  double originalPrice;
  String isFree;

  LocalComboOfferSubIngredients({
    required this.name,
    this.color,
    required this.price,
    required this.originalPrice,
    required this.isFree,
  });

  factory LocalComboOfferSubIngredients.fromJson(Map<String, dynamic> json) {
    return LocalComboOfferSubIngredients(
      name: json['name'],
      price: json['price'],
      originalPrice: json['originalPrice'],
      isFree: json['isFree'],
    );
  }

  static Map<String, dynamic> toJson(LocalComboOfferSubIngredients localComboOfferSubIngredients) {
    return {
      'name': localComboOfferSubIngredients.name,
      'price': localComboOfferSubIngredients.price,
      'originalPrice': localComboOfferSubIngredients.originalPrice,
      'isFree': localComboOfferSubIngredients.isFree,
    };
  }
}
