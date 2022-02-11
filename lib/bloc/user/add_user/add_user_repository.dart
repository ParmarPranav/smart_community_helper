part of 'add_user_bloc.dart';

class AddUserRepository {
  Users? _user;
  String _message = '';

  String get message {
    return _message;
  }

  Users? get user {
    return _user;
  }

  Future<void> addUser({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/user/adduser';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'User Added Successfully') {
          final userJson = responseJsonMap['user'] as dynamic;
          _user = Users.fromJson(userJson);
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
