import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_food_item_event.dart';

part 'get_food_item_repository.dart';

part 'get_food_item_state.dart';

class GetFoodItemBloc extends Bloc<GetFoodItemEvent, GetFoodItemState> {
  GetFoodItemRepository getFoodItemRepository = GetFoodItemRepository();

  GetFoodItemBloc() : super(GetFoodItemInitialState()) {
    on<GetFoodItemDataEvent>(_getFoodItemDataEvent);
    on<GetFoodItemDeleteEvent>(_getFoodItemDeleteEvent);
    on<GetFoodItemDeleteAllEvent>(_getFoodItemDeleteAllEvent);
  }

  void _getFoodItemDataEvent(GetFoodItemDataEvent event, Emitter<GetFoodItemState> emit) async {
    emit(GetFoodItemLoadingState());
    try {
      await getFoodItemRepository.getFoodItemList(event.data);
      if (getFoodItemRepository.message == 'Food Items Fetched Successfully') {
        emit(GetFoodItemSuccessState(
          getFoodItemRepository.foodItemList,
          getFoodItemRepository.message,
        ));
      } else {
        emit(GetFoodItemFailedState(
          getFoodItemRepository.foodItemList,
          getFoodItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodItemExceptionState(
        getFoodItemRepository.foodItemList,
        getFoodItemRepository.message,
      ));
    }
  }


  void _getFoodItemDeleteEvent(GetFoodItemDeleteEvent event, Emitter<GetFoodItemState> emit) async {
    emit(GetFoodItemLoadingItemState());
    try {
      await getFoodItemRepository.deleteFoodItem(event.data);
      if (getFoodItemRepository.message == 'Food Item Deleted Successfully') {
        emit(GetFoodItemSuccessState(
          getFoodItemRepository.foodItemList,
          getFoodItemRepository.message,
        ));
      } else {
        emit(GetFoodItemFailedState(
          getFoodItemRepository.foodItemList,
          getFoodItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodItemExceptionState(
        getFoodItemRepository.foodItemList,
        getFoodItemRepository.message,
      ));
    }
  }

  void _getFoodItemDeleteAllEvent(GetFoodItemDeleteAllEvent event, Emitter<GetFoodItemState> emit) async {
    emit(GetFoodItemLoadingItemState());
    try {
      await getFoodItemRepository.deleteAllFoodItem(event.idList);
      if (getFoodItemRepository.message == 'All Food Item Deleted Successfully') {
        emit(GetFoodItemSuccessState(
          getFoodItemRepository.foodItemList,
          getFoodItemRepository.message,
        ));
      } else {
        emit(GetFoodItemFailedState(
          getFoodItemRepository.foodItemList,
          getFoodItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodItemExceptionState(
        getFoodItemRepository.foodItemList,
        getFoodItemRepository.message,
      ));
    }
  }
}
