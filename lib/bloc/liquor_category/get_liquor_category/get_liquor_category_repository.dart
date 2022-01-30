part of 'get_liquor_category_bloc.dart';

class GetLiquorCategoryRepository {
  String _message = '';
  List<LiquorCategory> _liquorCategoryList = [];

  String get message {
    return _message;
  }

  List<LiquorCategory> get liquorCategoryList {
    return _liquorCategoryList;
  }

  Future<void> getLiquorCategoryList(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/liquorcategory/getliquorcategory';

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
        _liquorCategoryList.clear();
        if (_message == 'Liquor Category Fetched Successfully') {
          final liquorCategoryListJson = responseJsonMap['liquor_category'] as List<dynamic>;
          final liquorCategoryListData = liquorCategoryListJson.map((restaurantJson) {
            return LiquorCategory.fromJson(restaurantJson);
          }).toList();
          _liquorCategoryList = liquorCategoryListData;
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

  Future<void> updateStatusLiquorCategory(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/liquorcategory/updatestatusliquorcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Liquor Category Status Updated Successfully') {
        int index = _liquorCategoryList.indexWhere((element) => element.id == data['id']);
        LiquorCategory liquorCategory = _liquorCategoryList.removeAt(index);
        _liquorCategoryList.insert(
          index,
          LiquorCategory(
            id: liquorCategory.id,
            restaurantId: liquorCategory.restaurantId,
            name: liquorCategory.name,
            status: data['status'],
            createdAt: liquorCategory.createdAt,
            updatedAt: liquorCategory.updatedAt,
          ),
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteLiquorCategory(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/liquorcategory/deleteliquorcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Liquor Category Deleted Successfully') {
        _liquorCategoryList.removeWhere(
          (user) => user.id == data['id'],
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllLiquorCategory(List<Map<String, dynamic>> emailIdList) async {
    String url = '${ProjectConstant.hostUrl}admin/liquorcategory/deleteallliquorcategory';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'liquorcategory_arr': emailIdList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Liquor Category Deleted Successfully') {
        for (var emailData in emailIdList) {
          _liquorCategoryList.removeWhere((user) => user.id == emailData['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

}
