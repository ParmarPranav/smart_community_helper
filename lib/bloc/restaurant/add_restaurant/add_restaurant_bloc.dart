import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

part 'add_restaurant_event.dart';

part 'add_restaurant_repository.dart';

part 'add_restaurant_state.dart';

class AddRestaurantBloc extends Bloc<AddRestaurantEvent, AddRestaurantState> {
  AddRestaurantRepository addRestaurantRepository = AddRestaurantRepository();

  AddRestaurantBloc() : super(AddRestaurantInitialState()) {
    on<AddRestaurantAddEvent>(_addRestaurantAddEvent);
  }

  void _addRestaurantAddEvent(AddRestaurantAddEvent event, Emitter<AddRestaurantState> emit) async {
    emit(AddRestaurantLoadingState());
    try {
      await addRestaurantRepository.addRestaurant(
        data: event.addRestaurantData,
        businessLogo: event.businessLogo,
        coverPhoto: event.coverPhoto,
        photoGallery: event.photoGallery,
      );
      if (addRestaurantRepository.message == 'Restaurant Added Successfully') {
        emit(AddRestaurantSuccessState(
          addRestaurantRepository.restaurant,
          addRestaurantRepository.message,
        ));
      } else {
        emit(AddRestaurantFailureState(
          addRestaurantRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddRestaurantExceptionState(
        addRestaurantRepository.message,
      ));
    }
  }
}
