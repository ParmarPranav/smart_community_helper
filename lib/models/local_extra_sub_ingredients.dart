class LocalExtraSubIngredients {
  String name;
  double price;

  LocalExtraSubIngredients({
    required this.name,
    required this.price,
  });

  factory LocalExtraSubIngredients.fromJson(Map<String, dynamic> json) {
    return LocalExtraSubIngredients(
      name: json['name'],
      price: json['price']
    );
  }

  static Map<String, dynamic> toJson(LocalExtraSubIngredients localExtraSubIngredients) {
    return {
      'name': localExtraSubIngredients.name,
      'price': localExtraSubIngredients.price,
    };
  }
}
