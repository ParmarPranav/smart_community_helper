import 'package:intl/intl.dart';

class Permission {
  final int id;
  final int groupId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Permission({
    required this.id,
    required this.groupId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"] as int,
        groupId: json["group_id"] as int,
        name: json["name"] as String,
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  static Map<String, dynamic> toJson(Permission permission) => {
        "id": permission.id,
        "group_id": permission.groupId,
        "name": permission.name,
        "created_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(permission.createdAt),
        "updated_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(permission.updatedAt),
      };
}
