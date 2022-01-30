part of 'edit_liquor_item_bloc.dart';

class EditLiquorItemRepository {
  LiquorItem? _liquorItem;
  String _message = '';

  String get message {
    return _message;
  }

  LiquorItem? get liquorItem {
    return _liquorItem;
  }

  Future<void> editLiquorItem({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/liquoritem/editliquoritem';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Liquor Item Updated Successfully') {
          final liquorItemJson = responseJsonMap['liquor_item'] as dynamic;
          _liquorItem = LiquorItem.fromJson(liquorItemJson);
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
