import 'package:flutter/material.dart';

class LocalRemovableIngredients {
  String name;
  Color? color;

  LocalRemovableIngredients({
    required this.name,
    this.color,
  });

  factory LocalRemovableIngredients.fromJson(Map<String, dynamic> json) {
    return LocalRemovableIngredients(
      name: json['name'],
    );
  }

  static Map<String, dynamic> toJson(LocalRemovableIngredients localRemovableIngredients) {
    return {
      'name': localRemovableIngredients.name,
    };
  }
}
