part of 'get_order_delivery_boy_bloc.dart';

class GetOrderDeliveryBoyRepository {
  String _message = '';
  List<Order> _orderList = [];

  String get message {
    return _message;
  }

  List<Order> get orderList {
    return _orderList;
  }

  Future<void> getOrderDeliveryBoyList(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/deliveryboy/getorders';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _orderList.clear();
        if (_message == 'Order Fetched Successfully') {
          final orderListJson = responseJsonMap['order'] as List<dynamic>;
          final orderListData = orderListJson.map((orderJson) {
            return Order.fromJson(orderJson);
          }).toList();
          _orderList = orderListData;
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


}
