part of 'get_delivery_charges_bloc.dart';

class GetDeliveryChargesRepository {
  String _message = '';
  List<DeliveryCharges> _deliveryChargesList = [];

  String get message {
    return _message;
  }

  List<DeliveryCharges> get deliveryChargesList {
    return _deliveryChargesList;
  }

  Future<void> getDeliveryChargesList() async {
    String url = '${ProjectConstant.hostUrl}admin/deliverycharges/getdeliverycharges';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _deliveryChargesList.clear();
        if (_message == 'Delivery Charges Fetched Successfully') {
          final deliveryChargesListJson = responseJsonMap['delivery_charges'] as List<dynamic>;
          final deliveryChargesListData = deliveryChargesListJson.map((deliveryChargesJson) {
            return DeliveryCharges.fromJson(deliveryChargesJson);
          }).toList();
          _deliveryChargesList = deliveryChargesListData;
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

  Future<void> updateDeliveryCharges(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/deliverycharges/updatestatusdeliverycharges';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if(message == 'Status Status Updated Successfully'){
          _deliveryChargesList = _deliveryChargesList.map((deliveryStatus) {
            if (deliveryStatus.id == data['id']) {
              return DeliveryCharges(
                id: deliveryStatus.id,
                from: deliveryStatus.from,
                to: deliveryStatus.to,
                charge: deliveryStatus.charge,
                registerCityId: deliveryStatus.registerCityId,
                status: data['status'],
                city: deliveryStatus.city,
                createdAt: deliveryStatus.createdAt,
                updatedAt: deliveryStatus.updatedAt,
              );
            } else {
              return DeliveryCharges(
                id: deliveryStatus.id,
                from: deliveryStatus.from,
                to: deliveryStatus.to,
                charge: deliveryStatus.charge,
                registerCityId: deliveryStatus.registerCityId,
                status: deliveryStatus.status,
                city: deliveryStatus.city,
                createdAt: deliveryStatus.createdAt,
                updatedAt: deliveryStatus.updatedAt,
              );
            }
          }).toList();
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

  Future<void> deleteDeliveryCharges(Map<String, dynamic> emailId) async {
    String url = '${ProjectConstant.hostUrl}admin/deliverycharges/deletedeliverycharges';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(emailId), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Delivery Charges Deleted Successfully') {
        _deliveryChargesList.removeWhere(
          (user) => user.id == emailId['id'],
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllDeliveryCharges(List<Map<String, dynamic>> idList) async {
    String url = '${ProjectConstant.hostUrl}admin/deliverycharges/deletealldeliverycharges';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'deliverycharges_arr': idList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Delivery Charges Deleted Successfully') {
        for (var emailData in idList) {
          _deliveryChargesList.removeWhere((user) => user.id == emailData['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
