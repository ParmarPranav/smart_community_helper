import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_boy.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_food_item_event.dart';
part 'edit_food_item_repository.dart';
part 'edit_food_item_state.dart';

class EditDeliveryBoyBloc extends Bloc<EditDeliveryBoyEvent, EditDeliveryBoyState> {
  EditDeliveryBoyRepository editDeliveryBoyRepository = EditDeliveryBoyRepository();

  EditDeliveryBoyBloc() : super(EditDeliveryBoyInitialState()) {
    on<EditDeliveryBoyAddEvent>(_editDeliveryBoyAddEvent);
  }

  void _editDeliveryBoyAddEvent(EditDeliveryBoyAddEvent event, Emitter<EditDeliveryBoyState> emit) async {
    emit(EditDeliveryBoyLoadingState());
    try {
      await editDeliveryBoyRepository.editDeliveryBoy(
        data: event.editDeliveryBoyData,
      );
      if (editDeliveryBoyRepository.message == 'Delivery Boy Details Updated Successfully') {
        emit(EditDeliveryBoySuccessState(
          editDeliveryBoyRepository.deliveryBoy,
          editDeliveryBoyRepository.message,
        ));
      } else {
        emit(EditDeliveryBoyFailureState(
          editDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditDeliveryBoyExceptionState(
        editDeliveryBoyRepository.message,
      ));
    }
  }
}
