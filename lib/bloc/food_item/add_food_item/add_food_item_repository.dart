part of 'add_food_item_bloc.dart';

class AddFoodItemRepository {
  FoodItem? _foodItem;
  String _message = '';

  String get message {
    return _message;
  }

  FoodItem? get foodItem {
    return _foodItem;
  }

  Future<void> addFoodItem({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/fooditem/addfooditem';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Food Item Added Successfully') {
          final foodItemJson = responseJsonMap['food_item'] as dynamic;
          _foodItem = FoodItem.fromJson(foodItemJson);
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
