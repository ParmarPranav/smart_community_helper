import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/general_setting.dart';
import '../../../models/order.dart';

part 'get_general_setting_event.dart';
part 'get_general_setting_repository.dart';
part 'get_general_setting_state.dart';

class GetGeneralSettingBloc extends Bloc<GetGeneralSettingEvent, GetGeneralSettingState> {
  GetGeneralSettingRepository getGeneralSettingRepository = GetGeneralSettingRepository();

  GetGeneralSettingBloc() : super(GetGeneralSettingInitialState()) {
    on<GetGeneralSettingDataEvent>(_getGeneralSettingDataEvent);
    on<EditGeneralSettingEvent>(_editGeneralSettingDataEvent);
   }

  void _getGeneralSettingDataEvent(GetGeneralSettingDataEvent event, Emitter<GetGeneralSettingState> emit) async {
    emit(GetGeneralSettingLoadingState());
    try {
      await getGeneralSettingRepository.getGeneralSettingList();
      if (getGeneralSettingRepository.message == 'General Setting Fetched Successfully') {
        emit(GetGeneralSettingSuccessState(
          getGeneralSettingRepository.generalSetting,
          getGeneralSettingRepository.message,
        ));
      } else {
        emit(GetGeneralSettingFailedState(
          getGeneralSettingRepository.generalSetting,
          getGeneralSettingRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetGeneralSettingExceptionState(
        getGeneralSettingRepository.generalSetting,
        getGeneralSettingRepository.message,
      ));
    }
  }

  void _editGeneralSettingDataEvent(EditGeneralSettingEvent event, Emitter<GetGeneralSettingState> emit) async {
    emit(GetGeneralSettingLoadingState());
    try {
      await getGeneralSettingRepository.editGeneralSettingList(event.data);
      if (getGeneralSettingRepository.message == 'General Setting Updated Successfully') {
        emit(GetGeneralSettingSuccessState(
          getGeneralSettingRepository.generalSetting,
          getGeneralSettingRepository.message,
        ));
      } else {
        emit(GetGeneralSettingFailedState(
          getGeneralSettingRepository.generalSetting,
          getGeneralSettingRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetGeneralSettingExceptionState(
        getGeneralSettingRepository.generalSetting,
        getGeneralSettingRepository.message,
      ));
    }
  }

 
}
