import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/account_type.dart';
import '../../utils/project_constant.dart';

class GetAccountTypeRepository {
  String _message = '';
  List<AccountType> _accountTypeList = [];

  String get message {
    return _message;
  }

  List<AccountType> get accountTypeList {
    return _accountTypeList;
  }

  Future<void> getAccountTypeList() async {
    String url = '${ProjectConstant.hostUrl}admin/accounttype/getaccounttypes';

    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        _accountTypeList.clear();
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Account Types Fetched Successfully') {
          final accountTypeListJson = responseJsonMap['account_types'] as List<dynamic>;
          final accountTypeListData = accountTypeListJson.map((accountTypeJson) {
            return AccountType.fromJson(accountTypeJson);
          }).toList();
          _accountTypeList = accountTypeListData;
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

  Future<void> deleteAccountType(int accountTypeId) async {
    String url = '${ProjectConstant.hostUrl}admin/accounttype/deleteaccounttype';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'id': accountTypeId}), headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Account Type Deleted Successfully') {
          _accountTypeList.removeWhere((accountType) => accountType.id == accountTypeId);
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

  Future<void> deleteAllAccountType(List<Map<String, dynamic>> accountTypeList) async {
    String url = '${ProjectConstant.hostUrl}admin/accounttype/deleteallaccounttype';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'account_type_arr': accountTypeList}), headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Account Types Deleted Successfully') {
          for (var emailData in accountTypeList) {
            _accountTypeList.removeWhere((accountType) => accountType.id == emailData['id']);
          }
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
