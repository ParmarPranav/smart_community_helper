import 'package:intl/intl.dart';

class Restaurant {
  final int id;
  final String emailId;
  final String name;
  final String businessLogo;
  final String coverPhoto;
  final String photoGallery;
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
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      emailId: json['email_id'] as String,
      name: json['name'] as String,
      businessLogo: json['business_logo'] as String,
      coverPhoto: json['cover_photo'] as String,
      photoGallery: json['photo_gallery'] as String,
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
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
    );
  }
}
