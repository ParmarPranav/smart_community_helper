part of 'show_staff_bloc.dart';

class ShowStaffRepository {
  String _message = '';
  List<AdminDetails> _staffList = [];

  String get message {
    return _message;
  }

  List<AdminDetails> get staffList {
    return _staffList;
  }

  Future<void> getStaffList() async {
    String url = '${ProjectConstant.hostUrl}admin/staff/getstaff';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _staffList.clear();
        if (_message == 'Staff Fetched Successfully') {
          final staffListJson = responseJsonMap['staff'] as List<dynamic>;
          final staffListData = staffListJson.map((staffJson) {
            return AdminDetails.fromJson(staffJson);
          }).toList();
          _staffList = staffListData;
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

  Future<void> deleteStaff(String emailId) async {
    String url = '${ProjectConstant.hostUrl}admin/staff/deletestaff';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email_id': emailId,
          }),
          headers: {
            'Content-Type': 'application/json',
          });
      print(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Staff Deleted Successfully') {
        _staffList.removeWhere(
          (user) => user.emailId == emailId,
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllStaff(List<Map<String, dynamic>> emailIdList) async {
    String url = '${ProjectConstant.hostUrl}admin/staff/deleteallstaff';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'staff_arr': emailIdList,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Staff Deleted Successfully') {
        for (var emailData in emailIdList) {
          _staffList.removeWhere((user) => user.emailId == emailData['email_id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
