import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/users.dart';

part 'get_users_list_event.dart';

part 'get_users_list_repository.dart';

part 'get_users_list_state.dart';

class GetUsersListBloc extends Bloc<GetUsersListEvent, GetUsersListState> {
  GetUsersListRepository getUsersListRepository = GetUsersListRepository();

  GetUsersListBloc() : super(GetUsersListInitialState()) {
    on<GetUsersListDataEvent>(_getUsersListDataEvent);
  }

  void _getUsersListDataEvent(GetUsersListDataEvent event, Emitter<GetUsersListState> emit) async {
    emit(GetUsersListLoadingState());
    try {
      await getUsersListRepository.getUsersList();
      if (getUsersListRepository.message == 'Users Fetched Successfully') {
        emit(GetUsersListSuccessState(
          getUsersListRepository.usersList,
          getUsersListRepository.message,
        ));
      } else {
        emit(GetUsersListFailedState(
          getUsersListRepository.usersList,
          getUsersListRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersListExceptionState(
        getUsersListRepository.usersList,
        getUsersListRepository.message,
      ));
    }
  }
}
