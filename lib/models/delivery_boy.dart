import 'package:intl/intl.dart';

class DeliveryBoy {
  final int id;
  final int registerCityId;
  final String name;
  final String mobileNo;
  final String email;
  final String deliveryType;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String currentLocation;
  final String longitude;
  final String latitude;
  final String isVerify;
  final int noOfOrders;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DrivingLicenseDetails drivingLicenseDetails;
  final LiquorLicenseDetails? liquorLicenseDetails;
  final VehicleDetails vehicleDetails;


  DeliveryBoy({
    required this.id,
    required this.registerCityId,
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.deliveryType,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.currentLocation,
    required this.longitude,
    required this.latitude,
    required this.isVerify,
    required this.noOfOrders,
    required this.createdAt,
    required this.updatedAt,
    required this.drivingLicenseDetails,
    required this.liquorLicenseDetails,
    required this.vehicleDetails,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) {
    return DeliveryBoy(
      id: json["id"],
      registerCityId: json["register_city_id"],
      name: json["name"],
      mobileNo: json["mobile_no"],
      email: json["email"],
      deliveryType: json["delivery_type"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      pincode: json["pincode"],
      currentLocation: json["current_location"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      isVerify: json["is_verify"],
      noOfOrders: json["no_of_orders"],
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
