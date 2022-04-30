part of 'get_delivery_boy_bloc.dart';

class GetDeliveryBoyRepository {
  String _message = '';
  List<Vendor> _deliveryBoyList = [];

  String get message {
    return _message;
  }

  List<Vendor> get deliveryBoyList {
    return _deliveryBoyList;
  }

  Future<void> getDeliveryBoyList() async {
    String url = '${ProjectConstant.hostUrl}admin/vendor/getvendor';

    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _deliveryBoyList.clear();
        if (_message == 'Vendor Details Fetched Successfully') {
          final deliveryBoyListJson = responseJsonMap['vendor'] as List<dynamic>;
          final deliveryBoyListData = deliveryBoyListJson.map((deliveryBoyJson) {
            return Vendor.fromJson(deliveryBoyJson);
          }).toList();
          _deliveryBoyList = deliveryBoyListData;
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

  Future<void> deleteDeliveryBoy(Map<String, dynamic> emailId) async {
    String url = '${ProjectConstant.hostUrl}admin/deliveryboy/deletedeliveryboy';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(emailId), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Delivery Boy Deleted Successfully') {
        _deliveryBoyList.removeWhere(
          (user) => user.email == emailId,
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllDeliveryBoy(List<Map<String, dynamic>> idList) async {
    String url = '${ProjectConstant.hostUrl}admin/deliveryboy/deletealldeliveryboy';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'deliveryboy_arr': idList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Delivery Boy Deleted Successfully') {
        for (var data in idList) {
          _deliveryBoyList.removeWhere((user) => user.email == data['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
