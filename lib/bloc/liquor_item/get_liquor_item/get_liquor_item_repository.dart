part of 'get_liquor_item_bloc.dart';

class GetLiquorItemRepository {
  String _message = '';
  List<LiquorItem> _liquorItemList = [];

  String get message {
    return _message;
  }

  List<LiquorItem> get liquorItemList {
    return _liquorItemList;
  }

  Future<void> getLiquorItemList(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/liquoritem/getliquoritem';

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
        _liquorItemList.clear();
        if (_message == 'Liquor Items Fetched Successfully') {
          final liquorItemListJson = responseJsonMap['liquor_item'] as List<dynamic>;
          final liquorItemListData = liquorItemListJson.map((restaurantJson) {
            return LiquorItem.fromJson(restaurantJson);
          }).toList();
          _liquorItemList = liquorItemListData;
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

  Future<void> deleteLiquorItem(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/liquoritem/deleteliquoritem';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Liquor Item Deleted Successfully') {
        _liquorItemList.removeWhere(
          (user) => user.id == data['id'],
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllLiquorItem(List<Map<String, dynamic>> idList) async {
    String url = '${ProjectConstant.hostUrl}admin/liquoritem/deleteallliquoritem';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(
            {
              'liquoritem_arr': idList,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
          });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Liquor Item Deleted Successfully') {
        for (var data in idList) {
          _liquorItemList.removeWhere((user) => user.id == data['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
