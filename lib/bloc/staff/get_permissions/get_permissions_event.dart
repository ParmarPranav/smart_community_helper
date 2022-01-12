part of 'get_permissions_bloc.dart';

abstract class GetPermissionsListEvent extends Equatable {
  GetPermissionsListEvent();

  @override
  List<Object> get props => [];
}

class GetPermissionsListInitialEvent extends GetPermissionsListEvent {}
class GetPermissionsListDataEvent extends GetPermissionsListEvent {

  GetPermissionsListDataEvent();
}
