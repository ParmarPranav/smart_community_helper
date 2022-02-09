part of 'add_delivery_charges_blocs.dart';

class AddDeliveryChargesRepository {
  DeliveryCharges? _deliveryCharges;
  String _message = '';

  String get message {
    return _message;
  }

  DeliveryCharges? get deliveryCharges {
    return _deliveryCharges;
  }

  Future<void> addDeliveryCharges({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/deliverycharges/adddeliverycharges';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Delivery Charges Added Successfully') {
          final deliveryChargesJson = responseJsonMap['delivery_charges'] as dynamic;
          _deliveryCharges = DeliveryCharges.fromJson(deliveryChargesJson);
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
