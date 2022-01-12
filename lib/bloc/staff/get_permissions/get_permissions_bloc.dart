import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/permission_group.dart';
import '../../../repository/staff/get_permission_group_list_repository.dart';

part 'get_permissions_event.dart';

part 'get_permissions_state.dart';

class GetPermissionsListBloc extends Bloc<GetPermissionsListEvent, GetPermissionsListState> {
  GetPermissionGroupListRepository getPermissionsListRepository = GetPermissionGroupListRepository();

  GetPermissionsListBloc() : super(GetPermissionsListInitialState()) {
    on<GetPermissionsListDataEvent>(_getPermissionsListDataEvent);
    on<GetPermissionsListInitialEvent>((event, emit) => GetPermissionsListInitialState());
  }

  void _getPermissionsListDataEvent(GetPermissionsListDataEvent event, Emitter<GetPermissionsListState> emit) async {
    emit(GetPermissionsLoadingState());
    try {
      await getPermissionsListRepository.getPermissionGroupList();
      if (getPermissionsListRepository.message == 'Permissions Fetched Successfully') {
        emit(GetPermissionsListSuccessState(
          permissionGroupList: getPermissionsListRepository.permissionGroupList,
          message: getPermissionsListRepository.message,
        ));
      } else {
        emit(GetPermissionsListFailureState(
          permissionGroupList: getPermissionsListRepository.permissionGroupList,
          message: getPermissionsListRepository.message,
        ));
      }
    } catch (error) {
      emit(GetPermissionsListExceptionState(
        permissionGroupList: getPermissionsListRepository.permissionGroupList,
        message: getPermissionsListRepository.message,
      ));
    }
  }
}
