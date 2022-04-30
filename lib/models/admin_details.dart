import 'package:intl/intl.dart';

import 'staff_has_permission.dart';

class AdminDetails {
  final int id;
  final String email;
  final String name;
  final String password;
  final int accountTypeId;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminDetails({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.accountTypeId,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminDetails.fromJson(Map<String, dynamic> json) {
    return AdminDetails(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      accountTypeId: json['account_type_id'] as int,
      accountType: json['account_type'] as String,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
    );
  }

  static Map<String, dynamic> toJson(AdminDetails? adminDetails) {
    if (adminDetails != null) {
      return {
        'id': adminDetails.id,
        'email': adminDetails.email,
        'name': adminDetails.name,
        'password': adminDetails.password,
        'account_type_id': adminDetails.accountTypeId,
        'account_type': adminDetails.accountType,
        'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(adminDetails.createdAt),
        'updated_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(adminDetails.updatedAt),
      };
    }
    return {};
  }
}
