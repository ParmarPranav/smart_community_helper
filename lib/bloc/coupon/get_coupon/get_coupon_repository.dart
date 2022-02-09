part of 'get_coupon_bloc.dart';

class GetCouponsRepository {
  String _message = '';
  List<Coupon> _couponList = [];

  String get message {
    return _message;
  }

  List<Coupon> get couponList {
    return _couponList;
  }

  Future<void> getCouponList() async {
    String url = '${ProjectConstant.hostUrl}admin/coupon/getcoupons';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _couponList.clear();
        if (_message == 'Coupons Fetched Successfully') {
          final couponListJson = responseJsonMap['coupons'] as List<dynamic>;
          final couponListData = couponListJson.map((couponJson) {
            return Coupon.fromJson(couponJson);
          }).toList();
          _couponList = couponListData;
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

  Future<void> updateStatusCoupon(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/coupon/updatestatuscoupon';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Coupon Status Updated Successfully') {
        int index = _couponList.indexWhere((element) => element.id == data['id']);
        Coupon coupon = _couponList.removeAt(index);
        _couponList.insert(
          index,
          Coupon(
            id: coupon.id,
            couponCode: coupon.couponCode,
            couponTitle: coupon.couponTitle,
            couponSubtitle: coupon.couponSubtitle,
            validityEnd: coupon.validityEnd,
            discountCalculationType: coupon.discountCalculationType,
            discountType: coupon.discountType,
            discountValue: coupon.discountValue,
            minimumOrderPrice: coupon.minimumOrderPrice,
            maximumDiscountPrice: coupon.maximumDiscountPrice,
            noOfTimeUse: coupon.noOfTimeUse,
            userType: coupon.userType,
            status: data['status'],
            createdAt: coupon.createdAt,
            updatedAt: coupon.updatedAt,
          ),
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteCoupon(Map<String, dynamic> id) async {
    String url = '${ProjectConstant.hostUrl}admin/coupon/deletecoupon';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(id), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Coupon Deleted Successfully') {
        _couponList.removeWhere(
          (coupon) => coupon.id == id['id'],
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllCoupon(List<Map<String, dynamic>> emailIdList) async {
    String url = '${ProjectConstant.hostUrl}admin/coupon/deleteallcoupon';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'coupon_arr': emailIdList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Coupon Deleted Successfully') {
        for (var emailData in emailIdList) {
          _couponList.removeWhere((coupon) => coupon.id == emailData['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
