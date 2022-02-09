import 'package:intl/intl.dart';

class Restaurant {
  final int id;
  final String emailId;
  final String name;
  final String businessLogo;
  final String coverPhoto;
  final List<String> photoGallery;
  final String description;
  final String restaurantType;
  final String password;
  final String isOneTimePassword;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String mobileNo;
  final String landlineNo;
  final String currentLocation;
  final double longitude;
  final double latitude;
  final String isCashPayment;
  final String isOnlinePayment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<WorkingHourDetails> workingHourList;

  Restaurant({
    required this.id,
    required this.emailId,
    required this.name,
    required this.businessLogo,
    required this.coverPhoto,
    required this.photoGallery,
    required this.description,
    required this.restaurantType,
    required this.password,
    required this.isOneTimePassword,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.mobileNo,
    required this.landlineNo,
    required this.currentLocation,
    required this.longitude,
    required this.latitude,
    required this.isCashPayment,
    required this.isOnlinePayment,
    required this.createdAt,
    required this.updatedAt,
    required this.workingHourList,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      emailId: json['email_id'] as String,
      name: json['name'] as String,
      businessLogo: json['business_logo'] as String,
      coverPhoto: json['cover_photo'] as String,
      photoGallery: (json['photo_gallery'] as String) != '' ? (json['photo_gallery'] as String).split(",") : [],
      description: json['description'] as String,
      restaurantType: json['restaurant_type'] as String,
      password: json['password'] as String,
      isOneTimePassword: json['is_one_time_password'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      pincode: json['pincode'] as String,
      mobileNo: json['mobile_no'] as String,
      landlineNo: json['landline_no'] as String,
      currentLocation: json['current_location'] as String,
      longitude: double.parse(json['longitude'] as String),
      latitude: double.parse(json['latitude'] as String),
      isCashPayment: json['is_cash_payment'] as String,
      isOnlinePayment: json['is_online_payment'] as String,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      workingHourList: json.containsKey('restaurant_working_hours')
          ? (json['restaurant_working_hours'] as List<dynamic>).map((e) {
              return WorkingHourDetails.fromJson(e);
            }).toList()
          : [],
    );
  }
}

class WorkingHourDetails {
  final int id;
  final String restaurantId;
  final String day;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<WorkingHoursTimings> workingHoursTimingsList;

  WorkingHourDetails({
    required this.id,
    required this.restaurantId,
    required this.day,
    required this.createdAt,
    required this.updatedAt,
    required this.workingHoursTimingsList,
  });

  factory WorkingHourDetails.fromJson(Map<String, dynamic> json) => WorkingHourDetails(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        day: json["day"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        workingHoursTimingsList: List<WorkingHoursTimings>.from(json["working_hour_timings"].map((x) => WorkingHoursTimings.fromJson(x))),
      );
}

class WorkingHoursTimings {
  final int id;
  final int workingHourId;
  final String openTime;
  final String closeTime;
  final String isOpened;

  WorkingHoursTimings({
    required this.id,
    required this.workingHourId,
    required this.openTime,
    required this.closeTime,
    required this.isOpened,
  });

  factory WorkingHoursTimings.fromJson(Map<String, dynamic> json) => WorkingHoursTimings(
        id: json["id"],
        workingHourId: json["working_hour_id"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        isOpened: json["is_opened"],
      );
}
