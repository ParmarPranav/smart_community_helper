part of 'get_restaurants_bloc.dart';

class GetRestaurantsRepository {
  String _message = '';
  List<Restaurant> _restaurantList = [];

  String get message {
    return _message;
  }

  List<Restaurant> get restaurantList {
    return _restaurantList;
  }

  Future<void> getRestaurantList() async {
    String url = '${ProjectConstant.hostUrl}admin/restaurant/getrestaurants';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _restaurantList.clear();
        if (_message == 'Restaurants Fetched Successfully') {
          final restaurantListJson = responseJsonMap['restaurants'] as List<dynamic>;
          final restaurantListData = restaurantListJson.map((restaurantJson) {
            return Restaurant.fromJson(restaurantJson);
          }).toList();
          _restaurantList = restaurantListData;
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

  Future<void> deleteRestaurant(Map<String, dynamic> emailId) async {
    String url = '${ProjectConstant.hostUrl}admin/restaurant/deleterestaurant';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(emailId), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Restaurant Deleted Successfully') {
        _restaurantList.removeWhere(
          (user) => user.emailId == emailId,
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllRestaurant(List<Map<String, dynamic>> emailIdList) async {
    String url = '${ProjectConstant.hostUrl}admin/restaurant/deleteallrestaurant';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'restaurant_arr': emailIdList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Restaurant Deleted Successfully') {
        for (var emailData in emailIdList) {
          _restaurantList.removeWhere((user) => user.emailId == emailData['email_id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
