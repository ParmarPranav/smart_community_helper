part of 'edit_staff_bloc.dart';

class EditStaffRepository {
  AdminDetails? _adminDetails;

  String _message = '';

  String get message {
    return _message;
  }

  AdminDetails? get adminDetails {
    return _adminDetails;
  }

  Future<void> editStaff({required Map<String, dynamic> staffData}) async {
    String url = '${ProjectConstant.hostUrl}admin/staff/editstaff';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(staffData), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Staff Updated Successfully') {
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
