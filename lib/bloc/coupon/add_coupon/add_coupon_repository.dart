part of 'add_coupon_bloc.dart';

class AddCouponRepository {
  Coupon? _coupon;
  String _message = '';

  String get message {
    return _message;
  }

  Coupon? get coupon {
    return _coupon;
  }

  Future<void> addCoupon({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/coupon/addcoupon';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Coupon Added Successfully') {
          final couponJson = responseJsonMap['coupon'] as dynamic;
          _coupon = Coupon.fromJson(couponJson);
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
