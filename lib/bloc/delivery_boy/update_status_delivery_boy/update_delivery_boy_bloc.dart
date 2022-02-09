import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_boy.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'update_food_item_event.dart';
part 'update_food_item_repository.dart';
part 'update_food_item_state.dart';

class UpdateDeliveryBoyBloc extends Bloc<UpdateDeliveryBoyEvent, UpdateDeliveryBoyState> {
  UpdateDeliveryBoyRepository editDeliveryBoyRepository = UpdateDeliveryBoyRepository();

  UpdateDeliveryBoyBloc() : super(UpdateDeliveryBoyInitialState()) {
    on<UpdateDrivingLicenseEvent>(_updateDrivingLicenseEvent);
    on<UpdateLiquorLicenseEvent>(_updateLiquorLicenseEvent);
    on<UpdateVehicleCertificateEvent>(_updateVehicleCertificateEvent);
  }

  void _updateDrivingLicenseEvent(UpdateDrivingLicenseEvent event, Emitter<UpdateDeliveryBoyState> emit) async {
    emit(UpdateDeliveryBoyLoadingState());
    try {
      await editDeliveryBoyRepository.updateDrivingLicense(
        data: event.editDeliveryBoyData,
      );
      if (editDeliveryBoyRepository.message == 'Success!! Driving License Approved') {
        emit(UpdateDeliveryBoySuccessState(
          editDeliveryBoyRepository.deliveryBoy,
          editDeliveryBoyRepository.message,
        ));
      } else {
        emit(UpdateDeliveryBoyFailureState(
          editDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(UpdateDeliveryBoyExceptionState(
        editDeliveryBoyRepository.message,
      ));
    }
  }

  void _updateLiquorLicenseEvent(UpdateLiquorLicenseEvent event, Emitter<UpdateDeliveryBoyState> emit) async {
    emit(UpdateDeliveryBoyLoadingState());
    try {
      await editDeliveryBoyRepository.updateLiquorLicense(
        data: event.editDeliveryBoyData,
      );
      if (editDeliveryBoyRepository.message == 'Success!! Liquor License Approved') {
        emit(UpdateDeliveryBoySuccessState(
          editDeliveryBoyRepository.deliveryBoy,
          editDeliveryBoyRepository.message,
        ));
      } else {
        emit(UpdateDeliveryBoyFailureState(
          editDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(UpdateDeliveryBoyExceptionState(
        editDeliveryBoyRepository.message,
      ));
    }
  }
  void _updateVehicleCertificateEvent(UpdateVehicleCertificateEvent event, Emitter<UpdateDeliveryBoyState> emit) async {
    emit(UpdateDeliveryBoyLoadingState());
    try {
      await editDeliveryBoyRepository.updateVehicleCertificate(
        data: event.editDeliveryBoyData,
      );
      if (editDeliveryBoyRepository.message == 'Success!! Vehicle Certificate Approved') {
        emit(UpdateDeliveryBoySuccessState(
          editDeliveryBoyRepository.deliveryBoy,
          editDeliveryBoyRepository.message,
        ));
      } else {
        emit(UpdateDeliveryBoyFailureState(
          editDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(UpdateDeliveryBoyExceptionState(
        editDeliveryBoyRepository.message,
      ));
    }
  }
}
