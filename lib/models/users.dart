import 'package:intl/intl.dart';

class Users {
  final int id;
  final String name;
  final String mobileNo;
  final String email;
  final String currentLocation;
  final String latitude;
  final String longitude;
  final int walletMoney;
  final String isVerify;
  final DateTime createdAt;
  final DateTime updatedAt;

  Users({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.currentLocation,
    required this.latitude,
    required this.longitude,
    required this.walletMoney,
    required this.isVerify,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        name: json["name"],
        mobileNo: json["mobile_no"],
        email: json["email"],
        currentLocation: json["current_location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        walletMoney: json["wallet_money"],
        isVerify: json["is_verify"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile_no": mobileNo,
        "email": email,
        "current_location": currentLocation,
        "latitude": latitude,
        "longitude": longitude,
        "wallet_money": walletMoney,
        "is_verify": isVerify,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
