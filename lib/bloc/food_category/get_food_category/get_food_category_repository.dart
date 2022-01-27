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

  Future<void> getFoodCategoryList(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/getfoodcategory';

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
        _foodCategoryList.clear();
        if (_message == 'Food Category Fetched Successfully') {
          final foodCategoryListJson = responseJsonMap['food_category'] as List<dynamic>;
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

  Future<void> updateStatusFoodCategory(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/updatestatusfoodcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Food Category Status Updated Successfully') {
        int index = _foodCategoryList.indexWhere((element) => element.id == data['id']);
        FoodCategory foodCategory = _foodCategoryList.removeAt(index);
        _foodCategoryList.insert(
          index,
          FoodCategory(
            id: foodCategory.id,
            restaurantId: foodCategory.restaurantId,
            name: foodCategory.name,
            status: data['status'],
            createdAt: foodCategory.createdAt,
            updatedAt: foodCategory.updatedAt,
          ),
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteFoodCategory(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/foodcategory/deletefoodcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Food Category Deleted Successfully') {
        _foodCategoryList.removeWhere(
          (user) => user.id == data['id'],
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
      final response = await http.post(Uri.parse(url), body: jsonEncode({'foodcategory_arr': emailIdList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Food Category Deleted Successfully') {
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
