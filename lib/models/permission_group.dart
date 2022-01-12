import 'package:intl/intl.dart';

import 'permission.dart';

class PermissionGroup {
  final int id;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Permission> permissions;

  PermissionGroup({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
  });

  factory PermissionGroup.fromJson(Map<String, dynamic> json) => PermissionGroup(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        permissions: List<Permission>.from(json["permissions"].map((x) => Permission.fromJson(x))),
      );

  static Map<String, dynamic> toJson(PermissionGroup permissionGroup) => {
        "id": permissionGroup.id,
        "name": permissionGroup.name,
        "status": permissionGroup.status,
        "created_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(permissionGroup.createdAt),
        "updated_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(permissionGroup.updatedAt),
        "permissions": List<dynamic>.from(permissionGroup.permissions.map((x) => Permission.toJson(x))),
      };
}
