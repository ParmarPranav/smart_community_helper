part of 'get_food_item_bloc.dart';

class GetFoodItemRepository {
  String _message = '';
  List<FoodItem> _foodItemList = [];

  String get message {
    return _message;
  }

  List<FoodItem> get foodItemList {
    return _foodItemList;
  }

  Future<void> getFoodItemList(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/fooditem/getfooditem';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _foodItemList.clear();
        if (_message == 'Food Items Fetched Successfully') {
          final foodItemListJson = responseJsonMap['food_item'] as List<dynamic>;
          final foodItemListData = foodItemListJson.map((restaurantJson) {
            return FoodItem.fromJson(restaurantJson);
          }).toList();
          _foodItemList = foodItemListData;
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
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteFoodItem(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/fooditem/deletefooditem';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Food Item Deleted Successfully') {
        _foodItemList.removeWhere(
          (user) => user.id == data['id'],
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllFoodItem(List<Map<String, dynamic>> idList) async {
    String url = '${ProjectConstant.hostUrl}admin/fooditem/deleteallfooditem';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(
            {
              'fooditem_arr': idList,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
          });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Food Item Deleted Successfully') {
        for (var data in idList) {
          _foodItemList.removeWhere((user) => user.id == data['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
