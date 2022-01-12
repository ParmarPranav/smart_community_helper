class StaffHasPermission {
  final int id;
  final int permissionGroupId;
  final int permissionId;
  final String staffId;
  final String name;
  final String groupName;

  StaffHasPermission({
    required this.id,
    required this.permissionGroupId,
    required this.permissionId,
    required this.staffId,
    required this.name,
    required this.groupName,
  });

  factory StaffHasPermission.fromJson(Map<String, dynamic> json) => StaffHasPermission(
        id: json["id"] as int,
        permissionGroupId: json["permission_group_id"] as int,
        permissionId: json["permission_id"] as int,
        staffId: json["staff_id"] as String,
        name: json["name"] as String,
        groupName: json["group_name"] as String,
      );

  static Map<String, dynamic> toJson(StaffHasPermission staffHasPermission) => {
        "id": staffHasPermission.id,
        "permission_group_id": staffHasPermission.permissionGroupId,
        "permission_id": staffHasPermission.permissionId,
        "staff_id": staffHasPermission.staffId,
        "name": staffHasPermission.name,
        "group_name": staffHasPermission.groupName,
      };
}
