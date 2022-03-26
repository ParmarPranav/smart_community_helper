import 'package:intl/intl.dart';

class Users {
  final int id;
  final int registerCityId;
  final String name;
  final String mobileNo;
  final String email;
  final String currentLocation;
  final String latitude;
  final String longitude;
  final double walletMoney;
  final String isVerify;
  final String isCodEnabled;
  final String isBlock;
  final String isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  Users({
    required this.id,
    required this.registerCityId,
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.currentLocation,
    required this.latitude,
    required this.longitude,
    required this.walletMoney,
    required this.isVerify,
    required this.isCodEnabled,
    required this.isBlock,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        registerCityId: json["register_city_id"],
        name: json["name"],
        mobileNo: json["mobile_no"],
        email: json["email"],
        currentLocation: json["current_location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        walletMoney: json["wallet_money"],
        isVerify: json["is_verify"],
        isCodEnabled:  json["is_cod_enable"],
        isBlock: json["is_block"],
        isBanned: json["is_banned"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "register_city_id": registerCityId,
        "name": name,
        "mobile_no": mobileNo,
        "email": email,
        "current_location": currentLocation,
        "latitude": latitude,
        "longitude": longitude,
        "wallet_money": walletMoney,
        "is_verify": isVerify,
        "is_cod_enable": isCodEnabled,
        "is_block": isBlock,
        "is_banned": isBanned,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
