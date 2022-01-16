part of 'get_permissions_bloc.dart';

class GetPermissionGroupListRepository {
  String _message = '';
  List<PermissionGroup> _permissionGroupList = [];

  String get message {
    return _message;
  }

  List<PermissionGroup> get permissionGroupList => _permissionGroupList;

  Future<void> getPermissionGroupList() async {
    String url = '${ProjectConstant.hostUrl}admin/staff/getpermissiongrouplist';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        _permissionGroupList.clear();
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        final permissionGroupDataJson = responseJsonMap['permission_groups'] as List<dynamic>;
        final permissionGroupListData = permissionGroupDataJson.map((permissionGroupJson) {
          return PermissionGroup.fromJson(permissionGroupJson);
        }).toList();
        _permissionGroupList = permissionGroupListData;
      } else if (response.statusCode == 422) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
      } else {
        _message = "Server Connection Error !!";
      }
    } catch (error) {
      debugPrint(error.toString());
      _message = "Server Connection Error !!";
      throw error;
    }
  }
}
