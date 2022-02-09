part of 'get_register_city_bloc.dart';

class GetRegisterCityRepository {
  String _message = '';
  List<RegisterCity> _registerCityList = [];

  String get message {
    return _message;
  }

  List<RegisterCity> get registerCityList {
    return _registerCityList;
  }

  Future<void> getRegisterCityList() async {
    String url = '${ProjectConstant.hostUrl}admin/registercity/getregistercities';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _registerCityList.clear();
        if (_message == 'Register Cities Fetched Successfully') {
          final registerCityListJson = responseJsonMap['register_city'] as List<dynamic>;
          final registerCityListData = registerCityListJson.map((registerCityJson) {
            return RegisterCity.fromJson(registerCityJson);
          }).toList();
          _registerCityList = registerCityListData;
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
  //
  // Future<void> deleteRegisterCity(Map<String, dynamic> emailId) async {
  //   String url = '${ProjectConstant.hostUrl}admin/deliveryboy/deletedeliveryboy';
  //   try {
  //     final response = await http.post(Uri.parse(url), body: jsonEncode(emailId), headers: {
  //       'Content-Type': 'application/json',
  //     });
  //     debugPrint(response.body);
  //     final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
  //     final message = responseJsonMap['message'] as String;
  //     _message = message;
  //     if (_message == 'Delivery Boy Deleted Successfully') {
  //       _registerCityList.removeWhere(
  //         (user) => user.email == emailId,
  //       );
  //     }
  //   } catch (error) {
  //     print(error);
  //     _message = 'Server Connection Error';
  //     rethrow;
  //   }
  // }
  //
  // Future<void> deleteAllRegisterCity(List<Map<String, dynamic>> idList) async {
  //   String url = '${ProjectConstant.hostUrl}admin/deliveryboy/deletealldeliveryboy';
  //   try {
  //     final response = await http.post(Uri.parse(url), body: jsonEncode({'deliveryboy_arr': idList}), headers: {
  //       'Content-Type': 'application/json',
  //     });
  //     debugPrint(response.body);
  //     final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
  //     final message = responseJsonMap['message'] as String;
  //     _message = message;
  //     if (_message == 'All Delivery Boy Deleted Successfully') {
  //       for (var data in idList) {
  //         _registerCityList.removeWhere((user) => user.email == data['id']);
  //       }
  //     }
  //   } catch (error) {
  //     print(error);
  //     _message = 'Server Connection Error';
  //     rethrow;
  //   }
  // }
}
