import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/admin_details.dart';
import 'package:http/http.dart' as http;

import '../../../models/admin_details.dart';
import '../../../utils/project_constant.dart';

part 'show_staff_event.dart';

part 'show_staff_repository.dart';

part 'show_staff_state.dart';

class ShowStaffBloc extends Bloc<ShowStaffEvent, ShowStaffState> {
  ShowStaffRepository showStaffRepository = ShowStaffRepository();

  ShowStaffBloc() : super(ShowStaffInitialState()) {
    on<ShowStaffDataEvent>(_showStaffDataEvent);
    on<ShowStaffDeleteEvent>(_showStaffDeleteEvent);
    on<ShowStaffDeleteAllEvent>(_showStaffDeleteAllEvent);
  }

  void _showStaffDataEvent(ShowStaffDataEvent event, Emitter<ShowStaffState> emit) async {
    emit(ShowStaffLoadingState());
    try {
      await showStaffRepository.getStaffList();
      if (showStaffRepository.message == 'Staff Fetched Successfully') {
        emit(ShowStaffSuccessState(
          showStaffRepository.staffList,
          showStaffRepository.message,
        ));
      } else {
        emit(ShowStaffFailedState(
          showStaffRepository.staffList,
          showStaffRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(ShowStaffExceptionState(
        showStaffRepository.staffList,
        showStaffRepository.message,
      ));
    }
  }

  void _showStaffDeleteEvent(ShowStaffDeleteEvent event, Emitter<ShowStaffState> emit) async {
    emit(ShowStaffLoadingState());
    try {
      await showStaffRepository.deleteStaff(event.emailId);
      if (showStaffRepository.message == 'Staff Deleted Successfully') {
        emit(ShowStaffSuccessState(
          showStaffRepository.staffList,
          showStaffRepository.message,
        ));
      } else {
        emit(ShowStaffFailedState(
          showStaffRepository.staffList,
          showStaffRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(ShowStaffExceptionState(
        showStaffRepository.staffList,
        showStaffRepository.message,
      ));
    }
  }

  void _showStaffDeleteAllEvent(ShowStaffDeleteAllEvent event, Emitter<ShowStaffState> emit) async {
    emit(ShowStaffLoadingState());
    try {
      await showStaffRepository.deleteAllStaff(event.emailIdList);
      if (showStaffRepository.message == 'All Staff Deleted Successfully') {
        emit(ShowStaffSuccessState(
          showStaffRepository.staffList,
          showStaffRepository.message,
        ));
      } else {
        emit(ShowStaffFailedState(
          showStaffRepository.staffList,
          showStaffRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(ShowStaffExceptionState(
        showStaffRepository.staffList,
        showStaffRepository.message,
      ));
    }
  }
}
