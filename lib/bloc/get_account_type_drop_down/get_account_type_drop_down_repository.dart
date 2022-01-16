part of 'get_account_type_drop_down_bloc.dart';

class GetAccountTypeDropDownRepository {
  String _message = '';
  List<AccountTypeDropDown> _accountTypeDropDownList = [];

  String get message {
    return _message;
  }

  List<AccountTypeDropDown> get accountTypeList {
    return _accountTypeDropDownList;
  }

  Future<void> getAccountTypeDropDownList() async {
    String url = '${ProjectConstant.hostUrl}admin/auth/getaccounttypes';

    try {
      final response = await http.post(Uri.parse(url));
      print(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final msg = responseJsonMap['message'] as dynamic;
      _accountTypeDropDownList.clear();
      _message = msg;
      if (_message == 'Account Types Fetched Successfully') {
        final accountTypeListJson = responseJsonMap['account_types'] as List<dynamic>;
        final accountTypeListData = accountTypeListJson.map((accountTypeJson) {
          return AccountTypeDropDown.fromJson(accountTypeJson);
        }).toList();
        _accountTypeDropDownList = accountTypeListData;
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
