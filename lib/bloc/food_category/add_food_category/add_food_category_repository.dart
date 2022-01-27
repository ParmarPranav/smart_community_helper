part of 'add_food_category_bloc.dart';

class AddFoodCategoryRepository {
  FoodCategory? _foodCategory;
  String _message = '';

  String get message {
    return _message;
  }

  FoodCategory? get foodCategory {
    return _foodCategory;
  }

  Future<void> addFoodCategory({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/addfoodcategory';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Food Category Added Successfully') {
          final foodCategoryJson = responseJsonMap['food_category'] as dynamic;
          _foodCategory = FoodCategory.fromJson(foodCategoryJson);
        }
      } else if (response.statusCode == 422) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
      } else {
        _message = "Server Connection Error !!";
      }
    } catch (error) {
      print(error);
      _message = "Server Connection Error !!";
      rethrow;
    }
  }

}
