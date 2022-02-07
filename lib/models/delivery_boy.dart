import 'package:intl/intl.dart';

class DeliveryBoy {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final DrivingLicenseDetails drivingLicenseDetails;
  final LiquorLicenseDetails? liquorLicenseDetails;
  final VehicleDetails vehicleDetails;

  DeliveryBoy({
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
    required this.drivingLicenseDetails,
    required this.liquorLicenseDetails,
    required this.vehicleDetails,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) {
    return DeliveryBoy(
      id: json['id'] as int,
      emailId: json['email_id'] as String,
      name: json['name'] as String,
      businessLogo: json['business_logo'] as String,
      coverPhoto: json['cover_photo'] as String,
      photoGallery: (json['photo_gallery'] as String).split(","),
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
      drivingLicenseDetails: DrivingLicenseDetails.fromJson(json["driving_license_details"]),
      liquorLicenseDetails: json["liquor_license_details"] != null ? LiquorLicenseDetails.fromJson(json["liquor_license_details"]) : null,
      vehicleDetails: VehicleDetails.fromJson(json["vehicle_details"]),
    );
  }
}

class DrivingLicenseDetails {
  DrivingLicenseDetails({
    required this.id,
    required this.mobileNo,
    required this.licenseNo,
    required this.licenseFrontSide,
    required this.licenseBackSide,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String mobileNo;
  final String licenseNo;
  final String licenseFrontSide;
  final String licenseBackSide;
  final String isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DrivingLicenseDetails.fromJson(Map<String, dynamic> json) => DrivingLicenseDetails(
        id: json["id"],
        mobileNo: json["mobile_no"],
        licenseNo: json["license_no"],
        licenseFrontSide: json["license_front_side"],
        licenseBackSide: json["license_back_side"],
        isApproved: json["is_approved"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );
}

class LiquorLicenseDetails {
  final int id;
  final String mobileNo;
  final String licenseFrontSide;
  final String isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiquorLicenseDetails({
    required this.id,
    required this.mobileNo,
    required this.licenseFrontSide,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiquorLicenseDetails.fromJson(Map<String, dynamic> json) => LiquorLicenseDetails(
        id: json["id"],
        mobileNo: json["mobile_no"],
        licenseFrontSide: json["license_front_side"],
        isApproved: json["is_approved"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );
}

class VehicleDetails {
  final int id;
  final String mobileNo;
  final String vehicleName;
  final String vehicleModel;
  final String vehicleColor;
  final String registrationNo;
  final String frontRegistCerti;
  final String backRegistCerti;
  final String isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleDetails({
    required this.id,
    required this.mobileNo,
    required this.vehicleName,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.registrationNo,
    required this.frontRegistCerti,
    required this.backRegistCerti,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
        id: json["id"],
        mobileNo: json["mobile_no"],
        vehicleName: json["vehicle_name"],
        vehicleModel: json["vehicle_model"],
        vehicleColor: json["vehicle_color"],
        registrationNo: json["registration_no"],
        frontRegistCerti: json["front_regist_certi"],
        backRegistCerti: json["back_regist_certi"],
        isApproved: json["is_approved"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );
}
