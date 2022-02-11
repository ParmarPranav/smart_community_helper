import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/users.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_user_event.dart';
part 'edit_user_repository.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserRepository editUserRepository = EditUserRepository();

  EditUserBloc() : super(EditUserInitialState()) {
    on<EditUserEditEvent>(_editUserEditEvent);
  }

  void _editUserEditEvent(EditUserEditEvent event, Emitter<EditUserState> emit) async {
    emit(EditUserLoadingState());
    try {
      await editUserRepository.editUser(
        data: event.editUserData,
      );
      if (editUserRepository.message == 'User Updated Successfully') {
        emit(EditUserSuccessState(
          editUserRepository.user,
          editUserRepository.message,
        ));
      } else {
        emit(EditUserFailureState(
          editUserRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditUserExceptionState(
        editUserRepository.message,
      ));
    }
  }
}
