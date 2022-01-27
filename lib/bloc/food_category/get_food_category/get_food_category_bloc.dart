import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_food_category_event.dart';
part 'get_food_category_repository.dart';
part 'get_food_category_state.dart';

class GetFoodCategoryBloc extends Bloc<GetFoodCategoryEvent, GetFoodCategoryState> {
  GetFoodCategoryRepository getFoodCategoryRepository = GetFoodCategoryRepository();

  GetFoodCategoryBloc() : super(GetFoodCategoryInitialState()) {
    on<GetFoodCategoryDataEvent>(_getFoodCategoryDataEvent);
    on<GetFoodCategoryUpdateStatusEvent>(_getFoodCategoryUpdateStatusEvent);
    on<GetFoodCategoryDeleteEvent>(_getFoodCategoryDeleteEvent);
    on<GetFoodCategoryDeleteAllEvent>(_getFoodCategoryDeleteAllEvent);
  }

  void _getFoodCategoryDataEvent(GetFoodCategoryDataEvent event, Emitter<GetFoodCategoryState> emit) async {
    emit(GetFoodCategoryLoadingState());
    try {
      await getFoodCategoryRepository.getFoodCategoryList(event.data);
      if (getFoodCategoryRepository.message == 'Food Category Fetched Successfully') {
        emit(GetFoodCategorySuccessState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      } else {
        emit(GetFoodCategoryFailedState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodCategoryExceptionState(
        getFoodCategoryRepository.foodCategoryList,
        getFoodCategoryRepository.message,
      ));
    }
  }

  void _getFoodCategoryUpdateStatusEvent(GetFoodCategoryUpdateStatusEvent event, Emitter<GetFoodCategoryState> emit) async {
    emit(GetFoodCategoryLoadingItemState());
    try {
      await getFoodCategoryRepository.updateStatusFoodCategory(event.data);
      if (getFoodCategoryRepository.message == 'Food Category Status Updated Successfully') {
        emit(GetFoodCategorySuccessState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      } else {
        emit(GetFoodCategoryFailedState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodCategoryExceptionState(
        getFoodCategoryRepository.foodCategoryList,
        getFoodCategoryRepository.message,
      ));
    }
  }

  void _getFoodCategoryDeleteEvent(GetFoodCategoryDeleteEvent event, Emitter<GetFoodCategoryState> emit) async {
    emit(GetFoodCategoryLoadingItemState());
    try {
      await getFoodCategoryRepository.deleteFoodCategory(event.data);
      if (getFoodCategoryRepository.message == 'Food Category Deleted Successfully') {
        emit(GetFoodCategorySuccessState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      } else {
        emit(GetFoodCategoryFailedState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodCategoryExceptionState(
        getFoodCategoryRepository.foodCategoryList,
        getFoodCategoryRepository.message,
      ));
    }
  }

  void _getFoodCategoryDeleteAllEvent(GetFoodCategoryDeleteAllEvent event, Emitter<GetFoodCategoryState> emit) async {
    emit(GetFoodCategoryLoadingItemState());
    try {
      await getFoodCategoryRepository.deleteAllFoodCategory(event.idList);
      if (getFoodCategoryRepository.message == 'All Food Category Deleted Successfully') {
        emit(GetFoodCategorySuccessState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      } else {
        emit(GetFoodCategoryFailedState(
          getFoodCategoryRepository.foodCategoryList,
          getFoodCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetFoodCategoryExceptionState(
        getFoodCategoryRepository.foodCategoryList,
        getFoodCategoryRepository.message,
      ));
    }
  }
}
