import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/admin_details.dart';
import 'package:http/http.dart' as http;

import '../../../models/admin_details.dart';
import '../../../utils/project_constant.dart';

part 'add_staff_event.dart';

part 'add_staff_repository.dart';

part 'add_staff_state.dart';

class AddStaffBloc extends Bloc<AddStaffEvent, AddStaffState> {
  AddStaffRepository addStaffRepository = AddStaffRepository();

  AddStaffBloc() : super(AddStaffInitialState()) {
    on<AddStaffRegisterEvent>(_authenticationSignUpRegisterEvent);
  }

  void _authenticationSignUpRegisterEvent(AddStaffRegisterEvent event, Emitter<AddStaffState> emit) async {
    emit(AddStaffLoadingState());
    try {
      await addStaffRepository.addStaff(staffData: event.staffData);
      if (addStaffRepository.message == 'Staff Added Successfully') {
        emit(AddStaffSuccessState(
          addStaffRepository.adminDetails,
          addStaffRepository.message,
        ));
      } else {
        emit(AddStaffFailureState(addStaffRepository.message));
      }
    } catch (error) {
      emit(AddStaffExceptionState(addStaffRepository.message));
    }
  }
}
