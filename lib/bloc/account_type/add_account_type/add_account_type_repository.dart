part of 'add_account_type_bloc.dart';

class AddAccountTypeRepository {
  AccountType? _accountType;
  String _message = '';

  String get message {
    return _message;
  }

  AccountType? get accountType {
    return _accountType;
  }

  Future<void> addAccountType({required Map<String, dynamic> accountTypeData}) async {
    String url = '${ProjectConstant.hostUrl}admin/accounttype/addaccounttype';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(accountTypeData), headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Account Type Updated Successfully') {
          final accountTypeJson = responseJsonMap['account_type'] as dynamic;
          _accountType = AccountType.fromJson(accountTypeJson);
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
}
