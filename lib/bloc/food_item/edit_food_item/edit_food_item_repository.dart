part of 'edit_food_item_bloc.dart';

class EditFoodItemRepository {
  FoodItem? _foodCategory;
  String _message = '';

  String get message {
    return _message;
  }

  FoodItem? get foodCategory {
    return _foodCategory;
  }

  Future<void> editFoodItem({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/fooditem/editfood';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Food Item Updated Successfully') {
          final foodCategoryJson = responseJsonMap['food_category'] as dynamic;
          _foodCategory = FoodItem.fromJson(foodCategoryJson);
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
