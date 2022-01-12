import 'package:intl/intl.dart';

import 'staff_has_permission.dart';

class AdminDetails {
  final int id;
  final String emailId;
  final String name;
  final String password;
  final int accountTypeId;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<StaffHasPermission> permissionsList;

  AdminDetails({
    required this.id,
    required this.emailId,
    required this.name,
    required this.password,
    required this.accountTypeId,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
    required this.permissionsList,
  });

  factory AdminDetails.fromJson(Map<String, dynamic> json) {
    return AdminDetails(
      id: json['id'] as int,
      emailId: json['email_id'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      accountTypeId: json['account_type_id'] as int,
      accountType: json['account_type'] as String,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      permissionsList: json.containsKey('permissions') ? List<StaffHasPermission>.from(json["permissions"].map((x) => StaffHasPermission.fromJson(x))) : [],
    );
  }

  static Map<String, dynamic> toJson(AdminDetails? adminDetails) {
    if (adminDetails != null) {
      return {
        'id': adminDetails.id,
        'email_id': adminDetails.emailId,
        'name': adminDetails.name,
        'password': adminDetails.password,
        'account_type_id': adminDetails.accountTypeId,
        'account_type': adminDetails.accountType,
        'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(adminDetails.createdAt),
        'updated_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(adminDetails.updatedAt),
        "permissions": List<dynamic>.from(adminDetails.permissionsList.map((x) => StaffHasPermission.toJson(x))),
      };
    }
    return {};
  }
}
