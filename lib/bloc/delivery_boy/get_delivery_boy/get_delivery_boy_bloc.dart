import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_boy.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_delivery_boy_event.dart';

part 'get_delivery_boy_repository.dart';

part 'get_delivery_boy_state.dart';

class GetDeliveryBoyBloc extends Bloc<GetDeliveryBoyEvent, GetDeliveryBoyState> {
  GetDeliveryBoyRepository getDeliveryBoyRepository = GetDeliveryBoyRepository();

  GetDeliveryBoyBloc() : super(GetDeliveryBoyInitialState()) {
    on<GetDeliveryBoyDataEvent>(_getDeliveryBoyDataEvent);
    on<GetDeliveryBoyDeleteEvent>(_getDeliveryBoyDeleteEvent);
    on<GetDeliveryBoyDeleteAllEvent>(_getDeliveryBoyDeleteAllEvent);
  }

  void _getDeliveryBoyDataEvent(GetDeliveryBoyDataEvent event, Emitter<GetDeliveryBoyState> emit) async {
    emit(GetDeliveryBoyLoadingState());
    try {
      await getDeliveryBoyRepository.getDeliveryBoyList();
      if (getDeliveryBoyRepository.message == 'Delivery Boy Fetched Successfully') {
        emit(GetDeliveryBoySuccessState(
          getDeliveryBoyRepository.deliveryBoyList,
          getDeliveryBoyRepository.message,
        ));
      } else {
        emit(GetDeliveryBoyFailedState(
          getDeliveryBoyRepository.deliveryBoyList,
          getDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryBoyExceptionState(
        getDeliveryBoyRepository.deliveryBoyList,
        getDeliveryBoyRepository.message,
      ));
    }
  }

  void _getDeliveryBoyDeleteEvent(GetDeliveryBoyDeleteEvent event, Emitter<GetDeliveryBoyState> emit) async {
    emit(GetDeliveryBoyLoadingItemState());
    try {
      await getDeliveryBoyRepository.deleteDeliveryBoy(event.emailId);
      if (getDeliveryBoyRepository.message == 'DeliveryBoy Deleted Successfully') {
        emit(GetDeliveryBoySuccessState(
          getDeliveryBoyRepository.deliveryBoyList,
          getDeliveryBoyRepository.message,
        ));
      } else {
        emit(GetDeliveryBoyFailedState(
          getDeliveryBoyRepository.deliveryBoyList,
          getDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryBoyExceptionState(
        getDeliveryBoyRepository.deliveryBoyList,
        getDeliveryBoyRepository.message,
      ));
    }
  }

  void _getDeliveryBoyDeleteAllEvent(GetDeliveryBoyDeleteAllEvent event, Emitter<GetDeliveryBoyState> emit) async {
    emit(GetDeliveryBoyLoadingItemState());
    try {
      await getDeliveryBoyRepository.deleteAllDeliveryBoy(event.emailIdList);
      if (getDeliveryBoyRepository.message == 'All DeliveryBoy Deleted Successfully') {
        emit(GetDeliveryBoySuccessState(
          getDeliveryBoyRepository.deliveryBoyList,
          getDeliveryBoyRepository.message,
        ));
      } else {
        emit(GetDeliveryBoyFailedState(
          getDeliveryBoyRepository.deliveryBoyList,
          getDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryBoyExceptionState(
        getDeliveryBoyRepository.deliveryBoyList,
        getDeliveryBoyRepository.message,
      ));
    }
  }
}
