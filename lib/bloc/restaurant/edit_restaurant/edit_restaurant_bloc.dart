import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_restaurant_event.dart';

part 'edit_restaurant_repository.dart';

part 'edit_restaurant_state.dart';

class EditRestaurantBloc extends Bloc<EditRestaurantEvent, EditRestaurantState> {
  EditRestaurantRepository editRestaurantRepository = EditRestaurantRepository();

  EditRestaurantBloc() : super(EditRestaurantInitialState()) {
    on<EditRestaurantEditEvent>(_editRestaurantEditEvent);
  }

  void _editRestaurantEditEvent(EditRestaurantEditEvent event, Emitter<EditRestaurantState> emit) async {
    emit(EditRestaurantLoadingState());
    try {
      await editRestaurantRepository.editRestaurant(
        data: event.editRestaurantData,
      );
      if (editRestaurantRepository.message == 'Restaurant Updated Successfully') {
        emit(EditRestaurantSuccessState(
          editRestaurantRepository.restaurant,
          editRestaurantRepository.message,
        ));
      } else {
        emit(EditRestaurantFailureState(
          editRestaurantRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditRestaurantExceptionState(
        editRestaurantRepository.message,
      ));
    }
  }
}
