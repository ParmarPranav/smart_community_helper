import 'package:flutter/material.dart';

class LocalChoosableSubIngredients {
  String name;
  Color? color;

  LocalChoosableSubIngredients({
    required this.name,
    this.color,
  });

  factory LocalChoosableSubIngredients.fromJson(Map<String, dynamic> json) {
    return LocalChoosableSubIngredients(
      name: json['name'],
    );
  }

  static Map<String, dynamic> toJson(LocalChoosableSubIngredients localChoosableSubIngredients) {
    return {
      'name': localChoosableSubIngredients.name,
    };
  }
}
