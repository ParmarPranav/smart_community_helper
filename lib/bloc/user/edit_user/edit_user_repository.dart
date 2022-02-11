part of 'edit_user_bloc.dart';

class EditUserRepository {
  Users? _user;
  String _message = '';

  String get message {
    return _message;
  }

  Users? get user {
    return _user;
  }

  Future<void> editUser({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/user/edituser';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'User Updated Successfully') {
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
