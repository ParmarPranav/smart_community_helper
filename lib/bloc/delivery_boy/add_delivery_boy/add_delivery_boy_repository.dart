part of 'add_delivery_boy_blocs.dart';

class AddDeliveryBoyRepository {
  Vendor? _deliveryBoy;
  String _message = '';

  String get message {
    return _message;
  }

  Vendor? get deliveryBoy {
    return _deliveryBoy;
  }

  Future<void> addDeliveryBoy({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/deliveryboy/adddeliveryboy';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Delivery Boy Added Successfully') {
          final deliveryBoyJson = responseJsonMap['delivery_boy'] as dynamic;
          _deliveryBoy = Vendor.fromJson(deliveryBoyJson);
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
