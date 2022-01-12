import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/account_type.dart';
import '../../utils/project_constant.dart';

class EditAccountTypeRepository {
  AccountType? _accountType;
  String _message = '';

  String get message {
    return _message;
  }

  AccountType? get accountType {
    return _accountType;
  }

  Future<void> editAccountType({required Map<String, dynamic> editAccountTypeData}) async {
    String url = '${ProjectConstant.hostUrl}admin/accounttype/editaccounttype';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(editAccountTypeData), headers: {
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
