import 'package:flutter/foundation.dart';

class LocalPermission {

  final int permissionGroupId;
  final int permissionId;

  LocalPermission({
    required this.permissionGroupId,
    required this.permissionId,
  });

  factory LocalPermission.fromJson(Map<String, dynamic> json) => LocalPermission(
    permissionGroupId: json["permission_group_id"] as int,
    permissionId: json["permission_id"] as int,
  );

  static Map<String, dynamic> toJson(LocalPermission localPermission) => {
    "permission_group_id": localPermission.permissionGroupId,
    "permission_id": localPermission.permissionId,
  };
}
