part of 'get_food_category_bloc.dart';

class GetFoodFoodCategoryRepository {
  String _message = '';
  List<FoodCategory> _foodCategoryList = [];

  String get message {
    return _message;
  }

  List<FoodCategory> get foodCategoryList {
    return _foodCategoryList;
  }

  Future<void> getFoodCategoryList() async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/getfoodcategory';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _foodCategoryList.clear();
        if (_message == 'FoodCategorys Fetched Successfully') {
          final foodCategoryListJson = responseJsonMap['restaurants'] as List<dynamic>;
          final foodCategoryListData = foodCategoryListJson.map((restaurantJson) {
            return FoodCategory.fromJson(restaurantJson);
          }).toList();
          _foodCategoryList = foodCategoryListData;
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

  Future<void> deleteFoodCategory(Map<String, dynamic> emailId) async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/deletefoodcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(emailId), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'FoodCategory Deleted Successfully') {
        _foodCategoryList.removeWhere(
          (user) => user.id == emailId,
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllFoodCategory(List<Map<String, dynamic>> emailIdList) async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/deleteallfoodcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'restaurant_arr': emailIdList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All FoodCategory Deleted Successfully') {
        for (var emailData in emailIdList) {
          _foodCategoryList.removeWhere((user) => user.id == emailData['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
