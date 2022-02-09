import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_delivery_charges_event.dart';

part 'get_delivery_charges_repository.dart';

part 'get_delivery_charges_state.dart';

class GetDeliveryChargesBloc extends Bloc<GetDeliveryChargesEvent, GetDeliveryChargesState> {
  GetDeliveryChargesRepository getDeliveryChargesRepository = GetDeliveryChargesRepository();

  GetDeliveryChargesBloc() : super(GetDeliveryChargesInitialState()) {
    on<GetDeliveryChargesDataEvent>(_getDeliveryChargesDataEvent);
    on<UpdateDeliveryChargesEvent>(_updateDeliveryChargesDataEvent);
    on<GetDeliveryChargesDeleteEvent>(_getDeliveryChargesDeleteEvent);
    on<GetDeliveryChargesDeleteAllEvent>(_getDeliveryChargesDeleteAllEvent);
  }

  void _getDeliveryChargesDataEvent(GetDeliveryChargesDataEvent event, Emitter<GetDeliveryChargesState> emit) async {
    emit(GetDeliveryChargesLoadingState());
    try {
      await getDeliveryChargesRepository.getDeliveryChargesList();
      if (getDeliveryChargesRepository.message == 'Delivery Charges Fetched Successfully') {
        emit(GetDeliveryChargesSuccessState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      } else {
        emit(GetDeliveryChargesFailedState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryChargesExceptionState(
        getDeliveryChargesRepository.deliveryChargesList,
        getDeliveryChargesRepository.message,
      ));
    }
  }

  void _updateDeliveryChargesDataEvent(UpdateDeliveryChargesEvent event, Emitter<GetDeliveryChargesState> emit) async {
    emit(GetDeliveryChargesLoadingState());
    try {
      await getDeliveryChargesRepository.updateDeliveryCharges(event.data);
      if (getDeliveryChargesRepository.message == 'Status Updated Successfully') {
        emit(GetDeliveryChargesSuccessState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      } else {
        emit(GetDeliveryChargesFailedState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryChargesExceptionState(
        getDeliveryChargesRepository.deliveryChargesList,
        getDeliveryChargesRepository.message,
      ));
    }
  }

  void _getDeliveryChargesDeleteEvent(GetDeliveryChargesDeleteEvent event, Emitter<GetDeliveryChargesState> emit) async {
    emit(GetDeliveryChargesLoadingItemState());
    try {
      await getDeliveryChargesRepository.deleteDeliveryCharges(event.deiberyCharges);
      if (getDeliveryChargesRepository.message == 'Delivery Charges Deleted Successfully') {
        emit(GetDeliveryChargesSuccessState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      } else {
        emit(GetDeliveryChargesFailedState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryChargesExceptionState(
        getDeliveryChargesRepository.deliveryChargesList,
        getDeliveryChargesRepository.message,
      ));
    }
  }

  void _getDeliveryChargesDeleteAllEvent(GetDeliveryChargesDeleteAllEvent event, Emitter<GetDeliveryChargesState> emit) async {
    emit(GetDeliveryChargesLoadingItemState());
    try {
      await getDeliveryChargesRepository.deleteAllDeliveryCharges(event.deliveryChargesList);
      if (getDeliveryChargesRepository.message == 'All Delivery Charges Deleted Successfully') {
        emit(GetDeliveryChargesSuccessState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      } else {
        emit(GetDeliveryChargesFailedState(
          getDeliveryChargesRepository.deliveryChargesList,
          getDeliveryChargesRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDeliveryChargesExceptionState(
        getDeliveryChargesRepository.deliveryChargesList,
        getDeliveryChargesRepository.message,
      ));
    }
  }
}
