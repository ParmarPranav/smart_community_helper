part of 'get_permissions_bloc.dart';

abstract class GetPermissionsListState extends Equatable {
  GetPermissionsListState();

  @override
  List<Object> get props => [];
}

class GetPermissionsListInitialState extends GetPermissionsListState {}

class GetPermissionsLoadingState extends GetPermissionsListState {
  GetPermissionsLoadingState();
}

class GetPermissionsListSuccessState extends GetPermissionsListState {
  final List<PermissionGroup> permissionGroupList;
  final String message;

  GetPermissionsListSuccessState({
    required this.permissionGroupList,
    required this.message,
  });
}

class GetPermissionsListFailureState extends GetPermissionsListState {
  final List<PermissionGroup> permissionGroupList;
  final String message;

  GetPermissionsListFailureState({
    required this.permissionGroupList,
    required this.message,
  });
}

class GetPermissionsListExceptionState extends GetPermissionsListState {
  final List<PermissionGroup> permissionGroupList;
  final String message;

  GetPermissionsListExceptionState({
    required this.permissionGroupList,
    required this.message,
  });
}
