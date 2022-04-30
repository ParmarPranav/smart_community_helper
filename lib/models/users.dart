import 'package:intl/intl.dart';

class Users {
  final int id;
  final String email;
  final String name;
  final String description;
  final String password;

  final String address;

  final String city;

  final String state;

  final String country;

  final String mobileNo;
  final String isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  Users({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.password,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.mobileNo,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        email: json["email_id"],
        name: json["name"],
        description: json["description"],
        password: json["password"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        mobileNo: json["mobile_no"],
        isBanned: json["is_banned"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email":email,
        "name": name,
        "description": description,
        "password": password,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "mobile_no": mobileNo,
        "is_banned": isBanned,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
