import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/models/users.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

part 'add_user_event.dart';

part 'add_user_repository.dart';

part 'add_user_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  AddUserRepository addUserRepository = AddUserRepository();

  AddUserBloc() : super(AddUserInitialState()) {
    on<AddUserAddEvent>(_addUserAddEvent);
  }

  void _addUserAddEvent(AddUserAddEvent event, Emitter<AddUserState> emit) async {
    emit(AddUserLoadingState());
    try {
      await addUserRepository.addUser(
        data: event.addUserData,
      );
      if (addUserRepository.message == 'User Added Successfully') {
        emit(AddUserSuccessState(
          addUserRepository.user,
          addUserRepository.message,
        ));
      } else {
        emit(AddUserFailureState(
          addUserRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddUserExceptionState(
        addUserRepository.message,
      ));
    }
  }
}
