part of 'add_restaurant_bloc.dart';

class AddRestaurantRepository {
  Restaurant? _restaurant;
  String _message = '';

  String get message {
    return _message;
  }

  Restaurant? get restaurant {
    return _restaurant;
  }

  Future<void> addRestaurant({required Map<String, dynamic> data, required dynamic businessLogo, required dynamic coverPhoto, required List<dynamic> photoGallery}) async {
    String url = '${ProjectConstant.hostUrl}admin/restaurant/registerrestaurant';
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        'email_id': data['email_id'],
        'password': data['password'],
        'name': data['name'],
        'description': data['description'],
        'restaurant_type': data['restaurant_type'],
        'address': data['address'],
        'city': data['city'],
        'state': data['state'],
        'country': data['country'],
        'pincode': data['pincode'],
        'mobile_no': data['mobile_no'],
        'landline_no': data['landline_no'],
        'current_location': data['current_location'],
        'longitude': data['longitude'],
        'latitude': data['latitude'],
      });

      if (businessLogo is PickedFile) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'business_logo',
            await businessLogo.readAsBytes(),
            filename: businessLogo.path,
          ),
        );
      } else if (businessLogo is Uint8List) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'business_logo',
            businessLogo,
            filename: '${ProjectConstant.getRandomString(10)}.jpeg',
          ),
        );
      }

      if (coverPhoto is PickedFile) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'cover_photo',
            await coverPhoto.readAsBytes(),
            filename: coverPhoto.path,
          ),
        );
      } else if (coverPhoto is Uint8List) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'cover_photo',
            coverPhoto,
            filename: '${ProjectConstant.getRandomString(10)}.jpeg',
          ),
        );
      }

      if (photoGallery.length > 0) {
        photoGallery.forEach((item) async {
          if (item is PickedFile) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'photo_gallery',
                await item.readAsBytes(),
                filename: item.path,
              ),
            );
          } else if (item is Uint8List) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'photo_gallery',
                item,
                filename: '${ProjectConstant.getRandomString(10)}.jpeg',
              ),
            );
          }
        });
      }
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("#####" + responseBody);
        final responseJsonMap = jsonDecode(responseBody) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Restaurant Added Successfully') {
          final restaurantJson = responseJsonMap['restaurant'] as dynamic;
          _restaurant = Restaurant.fromJson(restaurantJson);
        }
      } else if (response.statusCode == 422) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("#####" + responseBody);
        final responseJsonMap = jsonDecode(responseBody) as Map<String, dynamic>;
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
