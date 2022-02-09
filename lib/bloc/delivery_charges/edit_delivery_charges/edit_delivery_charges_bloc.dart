import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_delivery_charges_event.dart';
part 'edit_delivery_charges_repository.dart';
part 'edit_delivery_charges_state.dart';

class EditDeliveryChargesBloc extends Bloc<EditDeliveryChargesEvent, EditDeliveryChargesState> {
  EditDeliveryChargesRepository editDeliveryChargesRepository = EditDeliveryChargesRepository();

  EditDeliveryChargesBloc() : super(EditDeliveryChargesInitialState()) {
    on<EditDeliveryChargesEditEvent>(_editDeliveryChargesEditEvent);
  }

  void _editDeliveryChargesEditEvent(EditDeliveryChargesEditEvent event, Emitter<EditDeliveryChargesState> emit) async {
    emit(EditDeliveryChargesLoadingState());
    try {
      await editDeliveryChargesRepository.editDeliveryCharges(
        data: event.editDeliveryChargesData,
      );
      if (editDeliveryChargesRepository.message == 'Delivery Charges Updated Successfully') {
        emit(EditDeliveryChargesSuccessState(
          editDeliveryChargesRepository.deliveryCharges,
          editDeliveryChargesRepository.message,
        ));
      } else {
        emit(EditDeliveryChargesFailureState(
          editDeliveryChargesRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditDeliveryChargesExceptionState(
        editDeliveryChargesRepository.message,
      ));
    }
  }
}
