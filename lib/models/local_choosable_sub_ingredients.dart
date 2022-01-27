class LocalChoosableSubIngredients {
  String name;

  LocalChoosableSubIngredients({required this.name});

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
