import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_restaurants_event.dart';

part 'get_restaurants_repository.dart';

part 'get_restaurants_state.dart';

class GetRestaurantsBloc extends Bloc<GetRestaurantsEvent, GetRestaurantsState> {
  GetRestaurantsRepository getRestaurantsRepository = GetRestaurantsRepository();

  GetRestaurantsBloc() : super(GetRestaurantsInitialState()) {
    on<GetRestaurantsDataEvent>(_getRestaurantsDataEvent);
    on<GetRestaurantsDeleteEvent>(_getRestaurantsDeleteEvent);
    on<GetRestaurantsDeleteAllEvent>(_getRestaurantsDeleteAllEvent);
  }

  void _getRestaurantsDataEvent(GetRestaurantsDataEvent event, Emitter<GetRestaurantsState> emit) async {
    emit(GetRestaurantsLoadingState());
    try {
      await getRestaurantsRepository.getRestaurantList();
      if (getRestaurantsRepository.message == 'Restaurants Fetched Successfully') {
        emit(GetRestaurantsSuccessState(
          getRestaurantsRepository.restaurantList,
          getRestaurantsRepository.message,
        ));
      } else {
        emit(GetRestaurantsFailedState(
          getRestaurantsRepository.restaurantList,
          getRestaurantsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetRestaurantsExceptionState(
        getRestaurantsRepository.restaurantList,
        getRestaurantsRepository.message,
      ));
    }
  }

  void _getRestaurantsDeleteEvent(GetRestaurantsDeleteEvent event, Emitter<GetRestaurantsState> emit) async {
    emit(GetRestaurantsLoadingItemState());
    try {
      await getRestaurantsRepository.deleteRestaurant(event.emailId);
      if (getRestaurantsRepository.message == 'Restaurant Deleted Successfully') {
        emit(GetRestaurantsSuccessState(
          getRestaurantsRepository.restaurantList,
          getRestaurantsRepository.message,
        ));
      } else {
        emit(GetRestaurantsFailedState(
          getRestaurantsRepository.restaurantList,
          getRestaurantsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetRestaurantsExceptionState(
        getRestaurantsRepository.restaurantList,
        getRestaurantsRepository.message,
      ));
    }
  }

  void _getRestaurantsDeleteAllEvent(GetRestaurantsDeleteAllEvent event, Emitter<GetRestaurantsState> emit) async {
    emit(GetRestaurantsLoadingItemState());
    try {
      await getRestaurantsRepository.deleteAllRestaurant(event.emailIdList);
      if (getRestaurantsRepository.message == 'All Restaurant Deleted Successfully') {
        emit(GetRestaurantsSuccessState(
          getRestaurantsRepository.restaurantList,
          getRestaurantsRepository.message,
        ));
      } else {
        emit(GetRestaurantsFailedState(
          getRestaurantsRepository.restaurantList,
          getRestaurantsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetRestaurantsExceptionState(
        getRestaurantsRepository.restaurantList,
        getRestaurantsRepository.message,
      ));
    }
  }
}
