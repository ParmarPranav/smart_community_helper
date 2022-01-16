part of 'add_staff_bloc.dart';

class AddStaffRepository {
  AdminDetails? _adminDetails;

  String _message = '';

  String get message {
    return _message;
  }

  AdminDetails? get adminDetails {
    return _adminDetails;
  }

  Future<void> addStaff({required Map<String, dynamic> staffData}) async {
    String url = '${ProjectConstant.hostUrl}admin/staff/addstaff';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(staffData), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Staff Added Successfully') {
          final staffJson = responseJsonMap['staff'] as dynamic;
          _adminDetails = AdminDetails.fromJson(staffJson);
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
