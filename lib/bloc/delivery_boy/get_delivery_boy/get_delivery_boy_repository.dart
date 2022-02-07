part of 'get_delivery_boy_bloc.dart';

class GetDeliveryBoyRepository {
  String _message = '';
  List<DeliveryBoy> _deliveryBoyList = [];

  String get message {
    return _message;
  }

  List<DeliveryBoy> get deliveryBoyList {
    return _deliveryBoyList;
  }

  Future<void> getDeliveryBoyList() async {
    String url = '${ProjectConstant.hostUrl}admin/deliveryboy/getdeliveryboy';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _deliveryBoyList.clear();
        if (_message == 'Delivery Boy Fetched Successfully') {
          final deliveryBoyListJson = responseJsonMap['delivery_boy'] as List<dynamic>;
          final deliveryBoyListData = deliveryBoyListJson.map((deliveryBoyJson) {
            return DeliveryBoy.fromJson(deliveryBoyJson);
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
    String url = '${ProjectConstant.hostUrl}admin/deliveryBoy/deletedeliveryBoy';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(emailId), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'DeliveryBoy Deleted Successfully') {
        _deliveryBoyList.removeWhere(
          (user) => user.emailId == emailId,
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllDeliveryBoy(List<Map<String, dynamic>> emailIdList) async {
    String url = '${ProjectConstant.hostUrl}admin/deliveryBoy/deletealldeliveryBoy';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'deliveryBoy_arr': emailIdList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All DeliveryBoy Deleted Successfully') {
        for (var emailData in emailIdList) {
          _deliveryBoyList.removeWhere((user) => user.emailId == emailData['email_id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
