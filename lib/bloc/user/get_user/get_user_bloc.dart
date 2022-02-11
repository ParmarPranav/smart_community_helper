import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/users.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_user_event.dart';
part 'get_user_repository.dart';
part 'get_user_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  GetUsersRepository getUsersRepository = GetUsersRepository();

  GetUsersBloc() : super(GetUsersInitialState()) {
    on<GetUsersDataEvent>(_getUsersDataEvent);
    on<GetUsersDeleteEvent>(_getUsersDeleteEvent);
    on<UpdateUsersIsCodEnableEvent>(_updateCodEnableStatusEvent);
    on<UpdateUsersIsBlockEvent>(_updateBlockStatusEvent);
    on<UpdateUsersIsBannedEvent>(_updateBannedStatusEvent);
    on<GetUsersDeleteAllEvent>(_getUsersDeleteAllEvent);
  }

  void _getUsersDataEvent(GetUsersDataEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingState());
    try {
      await getUsersRepository.getUsersList(event.data);
      if (getUsersRepository.message == 'User Fetched Successfully') {
        emit(GetUsersSuccessState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      } else {
        emit(GetUsersFailedState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        getUsersRepository.userList,
        getUsersRepository.message,
      ));
    }
  }

  void _updateCodEnableStatusEvent(UpdateUsersIsCodEnableEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingItemState());
    try {
      await getUsersRepository.updateCodEnableStatus(event.data);
      if (getUsersRepository.message == 'Status Updated Successfully') {
        emit(GetUsersSuccessState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      } else {
        emit(GetUsersFailedState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        getUsersRepository.userList,
        getUsersRepository.message,
      ));
    }
  }

  void _updateBlockStatusEvent(UpdateUsersIsBlockEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingItemState());
    try {
      await getUsersRepository.updateBlockStatus(event.data);
      if (getUsersRepository.message == 'Status Updated Successfully') {
        emit(GetUsersSuccessState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      } else {
        emit(GetUsersFailedState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        getUsersRepository.userList,
        getUsersRepository.message,
      ));
    }

  }

  void _updateBannedStatusEvent(UpdateUsersIsBannedEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingItemState());
    try {
      await getUsersRepository.updateBannedStatus(event.data);
      if (getUsersRepository.message == 'Status Updated Successfully') {
        emit(GetUsersSuccessState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      } else {
        emit(GetUsersFailedState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        getUsersRepository.userList,
        getUsersRepository.message,
      ));
    }
  }

  void _getUsersDeleteEvent(GetUsersDeleteEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingItemState());
    try {
      await getUsersRepository.deleteUsers(event.user);
      if (getUsersRepository.message == 'User Deleted Successfully') {
        emit(GetUsersSuccessState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      } else {
        emit(GetUsersFailedState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        getUsersRepository.userList,
        getUsersRepository.message,
      ));
    }
  }

  void _getUsersDeleteAllEvent(GetUsersDeleteAllEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingItemState());
    try {
      await getUsersRepository.deleteAllUsers(event.idList);
      if (getUsersRepository.message == 'All User Deleted Successfully') {
        emit(GetUsersSuccessState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      } else {
        emit(GetUsersFailedState(
          getUsersRepository.userList,
          getUsersRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        getUsersRepository.userList,
        getUsersRepository.message,
      ));
    }
  }
}
