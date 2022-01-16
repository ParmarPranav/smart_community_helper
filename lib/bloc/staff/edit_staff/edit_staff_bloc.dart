import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../models/admin_details.dart';
import '../../../utils/project_constant.dart';

part 'edit_staff_event.dart';

part 'edit_staff_repository.dart';

part 'edit_staff_state.dart';

class EditStaffBloc extends Bloc<EditStaffEvent, EditStaffState> {
  EditStaffRepository editStaffRepository = EditStaffRepository();

  EditStaffBloc() : super(EditStaffInitialState()) {
    on<EditStaffRegisterEvent>(_editStaffRegisterEvent);
  }

  void _editStaffRegisterEvent(EditStaffRegisterEvent event, Emitter<EditStaffState> emit) async {
    emit(EditStaffLoadingState());
    try {
      await editStaffRepository.editStaff(staffData: event.staffData);
      if (editStaffRepository.message == 'Staff Updated Successfully') {
        emit(EditStaffSuccessState(
          editStaffRepository.adminDetails,
          editStaffRepository.message,
        ));
      } else {
        emit(EditStaffFailureState(
          editStaffRepository.message,
        ));
      }
    } catch (error) {
      emit(EditStaffExceptionState(
        editStaffRepository.message,
      ));
    }
  }
}
