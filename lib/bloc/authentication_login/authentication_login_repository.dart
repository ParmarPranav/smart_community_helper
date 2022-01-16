part of 'authentication_login_bloc.dart';

class AuthenticationLoginRepository {
  String _message = '';
  AdminDetails? _adminDetails;

  AdminDetails? get adminDetails {
    return _adminDetails;
  }

  String get message {
    return _message;
  }

  Future<void> login(Map<String, dynamic> data) async {
    String url = "${ProjectConstant.hostUrl}admin/auth/login";

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseJsonMap.containsKey('admin_details')) {
        final json = responseJsonMap['admin_details'] as Map<String, dynamic>;
        _adminDetails = AdminDetails(
          id: json['id'] as int,
          emailId: json['email_id'] as String,
          name: json['name'] as String,
          password: data['password'] as String,
          accountTypeId: json['account_type_id'] as int,
          accountType: json['account_type'] as String,
          createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
          updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
          permissionsList: json.containsKey('permissions')
              ? List<StaffHasPermission>.from(json["permissions"].map((x) => StaffHasPermission.fromJson(x)))
              : [], // permissionsList: json.containsKey('permissions') ? List<StaffHasPermission>.from(json["permissions"].map((x) => StaffHasPermission.fromJson(x))) : [],
        );
      }
      final message = responseJsonMap['message'] as String;
      _message = message;
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
