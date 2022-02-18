part of 'get_general_setting_bloc.dart';

class GetGeneralSettingRepository {
  String _message = '';
  GeneralSetting? _generalSetting;

  String get message {
    return _message;
  }

  GeneralSetting? get generalSetting {
    return _generalSetting;
  }

  Future<void> getGeneralSettingList() async {
    String url = '${ProjectConstant.hostUrl}admin/generalsetting/getgeneralsetting';

    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'General Setting Fetched Successfully') {
          final generalSettingsJson = responseJsonMap['general_setting'] as dynamic;
          _generalSetting = GeneralSetting.fromJson(generalSettingsJson);
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

  Future<void> editGeneralSettingList(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/generalsetting/editgeneralsetting';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'General Setting Updated Successfully') {
          _generalSetting = GeneralSetting(
            id: data['id'],
            isDeliveryFree: data['is_delivery_free'],
            foodServiceChargePercent: data['food_service_charge_percent'],
            liquorServiceChargePercent: data['liquor_service_charge_percent'],
            airportDeliveryCharge: data['airport_delivery_charge'],
            railwayDeliveryCharge: data['railway_delivery_charge'],
            minimumOrderPrice: data['minimum_order_price'],
            taxes: data['taxes'],
            surCharge:  data['surcharge'],
          );
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
