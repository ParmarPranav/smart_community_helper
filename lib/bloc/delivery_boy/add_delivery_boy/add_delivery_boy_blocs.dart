import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../models/delivery_boy.dart';

part 'add_delivery_boy_event.dart';

part 'add_delivery_boy_repository.dart';

part 'add_delivery_boy_state.dart';

class AddDeliveryBoyBloc extends Bloc<AddDeliveryBoyEvent, AddDeliveryBoyState> {
  AddDeliveryBoyRepository addDeliveryBoyRepository = AddDeliveryBoyRepository();

  AddDeliveryBoyBloc() : super(AddDeliveryBoyInitialState()) {
    on<AddDeliveryBoyAddEvent>(_addDeliveryBoyAddEvent);
  }

  void _addDeliveryBoyAddEvent(AddDeliveryBoyAddEvent event, Emitter<AddDeliveryBoyState> emit) async {
    emit(AddDeliveryBoyLoadingState());
    try {
      await addDeliveryBoyRepository.addDeliveryBoy(
        data: event.addDeliveryBoyData,
      );
      if (addDeliveryBoyRepository.message == 'Delivery Boy Added Successfully') {
        emit(AddDeliveryBoySuccessState(
          addDeliveryBoyRepository.deliveryBoy,
          addDeliveryBoyRepository.message,
        ));
      } else {
        emit(AddDeliveryBoyFailureState(
          addDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddDeliveryBoyExceptionState(
        addDeliveryBoyRepository.message,
      ));
    }
  }
}
