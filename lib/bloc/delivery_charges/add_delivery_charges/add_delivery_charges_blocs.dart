import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

part 'add_delivery_charges_event.dart';

part 'add_delivery_charges_repository.dart';

part 'add_delivery_charges_state.dart';

class AddDeliveryChargesBloc extends Bloc<AddDeliveryChargesEvent, AddDeliveryChargesState> {
  AddDeliveryChargesRepository addDeliveryChargesRepository = AddDeliveryChargesRepository();

  AddDeliveryChargesBloc() : super(AddDeliveryChargesInitialState()) {
    on<AddDeliveryChargesAddEvent>(_addDeliveryChargesAddEvent);
  }

  void _addDeliveryChargesAddEvent(AddDeliveryChargesAddEvent event, Emitter<AddDeliveryChargesState> emit) async {
    emit(AddDeliveryChargesLoadingState());
    try {
      await addDeliveryChargesRepository.addDeliveryCharges(
        data: event.addDeliveryChargesData,
      );
      if (addDeliveryChargesRepository.message == 'Delivery Charges Added Successfully') {
        emit(AddDeliveryChargesSuccessState(
          addDeliveryChargesRepository.deliveryCharges,
          addDeliveryChargesRepository.message,
        ));
      } else {
        emit(AddDeliveryChargesFailureState(
          addDeliveryChargesRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddDeliveryChargesExceptionState(
        addDeliveryChargesRepository.message,
      ));
    }
  }
}
