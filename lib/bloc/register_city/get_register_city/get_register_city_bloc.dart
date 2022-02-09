import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_boy.dart';
import 'package:food_hunt_admin_app/models/register_city.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_register_city_event.dart';

part 'get_register_city_repository.dart';

part 'get_register_city_state.dart';

class GetRegisterCityBloc extends Bloc<GetRegisterCityEvent, GetRegisterCityState> {
  GetRegisterCityRepository getRegisterCityRepository = GetRegisterCityRepository();

  GetRegisterCityBloc() : super(GetRegisterCityInitialState()) {
    on<GetRegisterCityDataEvent>(_getRegisterCityDataEvent);

  }

  void _getRegisterCityDataEvent(GetRegisterCityDataEvent event, Emitter<GetRegisterCityState> emit) async {
    emit(GetRegisterCityLoadingState());
    try {
      await getRegisterCityRepository.getRegisterCityList();
      if (getRegisterCityRepository.message == 'Register Cities Fetched Successfully') {
        emit(GetRegisterCitySuccessState(
          getRegisterCityRepository.registerCityList,
          getRegisterCityRepository.message,
        ));
      } else {
        emit(GetRegisterCityFailedState(
          getRegisterCityRepository.registerCityList,
          getRegisterCityRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetRegisterCityExceptionState(
        getRegisterCityRepository.registerCityList,
        getRegisterCityRepository.message,
      ));
    }
  }

  // void _getRegisterCityDeleteEvent(GetRegisterCityDeleteEvent event, Emitter<GetRegisterCityState> emit) async {
  //   emit(GetRegisterCityLoadingItemState());
  //   try {
  //     await getRegisterCityRepository.deleteRegisterCity(event.emailId);
  //     if (getRegisterCityRepository.message == 'Delivery Boy Deleted Successfully') {
  //       emit(GetRegisterCitySuccessState(
  //         getRegisterCityRepository.deliveryBoyList,
  //         getRegisterCityRepository.message,
  //       ));
  //     } else {
  //       emit(GetRegisterCityFailedState(
  //         getRegisterCityRepository.deliveryBoyList,
  //         getRegisterCityRepository.message,
  //       ));
  //     }
  //   } catch (error) {
  //     print(error);
  //     emit(GetRegisterCityExceptionState(
  //       getRegisterCityRepository.deliveryBoyList,
  //       getRegisterCityRepository.message,
  //     ));
  //   }
  // }
  //
  // void _getRegisterCityDeleteAllEvent(GetRegisterCityDeleteAllEvent event, Emitter<GetRegisterCityState> emit) async {
  //   emit(GetRegisterCityLoadingItemState());
  //   try {
  //     await getRegisterCityRepository.deleteAllRegisterCity(event.emailIdList);
  //     if (getRegisterCityRepository.message == 'All Delivery Boy Deleted Successfully') {
  //       emit(GetRegisterCitySuccessState(
  //         getRegisterCityRepository.deliveryBoyList,
  //         getRegisterCityRepository.message,
  //       ));
  //     } else {
  //       emit(GetRegisterCityFailedState(
  //         getRegisterCityRepository.deliveryBoyList,
  //         getRegisterCityRepository.message,
  //       ));
  //     }
  //   } catch (error) {
  //     print(error);
  //     emit(GetRegisterCityExceptionState(
  //       getRegisterCityRepository.deliveryBoyList,
  //       getRegisterCityRepository.message,
  //     ));
  //   }
  // }
}
