part of 'edit_restaurant_bloc.dart';

class EditRestaurantRepository {
  Restaurant? _restaurant;
  String _message = '';

  String get message {
    return _message;
  }

  Restaurant? get restaurant {
    return _restaurant;
  }

  Future<void> editRestaurant({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/restaurant/editrestaurant';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Restaurant Updated Successfully') {
          final restaurantJson = responseJsonMap['restaurant'] as dynamic;
          _restaurant = Restaurant.fromJson(restaurantJson);
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
