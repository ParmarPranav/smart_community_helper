part of 'get_users_list_bloc.dart';

class GetUsersListRepository {
  String _message = '';
  List<Users> _usersList = [];

  String get message {
    return _message;
  }

  List<Users> get usersList {
    return _usersList;
  }

  Future<void> getUsersList() async {
    String url = '${ProjectConstant.hostUrl}admin/coupon/getuserslist';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _usersList.clear();
        if (_message == 'Users Fetched Successfully') {
          final usersListJson = responseJsonMap['users'] as List<dynamic>;
          final usersListData = usersListJson.map((usersJson) {
            return Users.fromJson(usersJson);
          }).toList();
          _usersList = usersListData;
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
