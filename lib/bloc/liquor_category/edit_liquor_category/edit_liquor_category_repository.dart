part of 'edit_liquor_category_bloc.dart';

class EditLiquorCategoryRepository {
  LiquorCategory? _liquorCategory;
  String _message = '';

  String get message {
    return _message;
  }

  LiquorCategory? get liquorCategory {
    return _liquorCategory;
  }

  Future<void> editLiquorCategory({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/liquorcategory/editliquorcategory';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Liquor Category Updated Successfully') {
          final liquorCategoryJson = responseJsonMap['liquor_category'] as dynamic;
          _liquorCategory = LiquorCategory.fromJson(liquorCategoryJson);
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
