import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'add_food_item_event.dart';

part 'add_food_item_repository.dart';

part 'add_food_item_state.dart';

class AddFoodItemBloc extends Bloc<AddFoodItemEvent, AddFoodItemState> {
  AddFoodItemRepository addFoodItemRepository = AddFoodItemRepository();

  AddFoodItemBloc() : super(AddFoodItemInitialState()) {
    on<AddFoodItemAddEvent>(_addFoodItemAddEvent);
  }

  void _addFoodItemAddEvent(AddFoodItemAddEvent event, Emitter<AddFoodItemState> emit) async {
    emit(AddFoodItemLoadingState());
    try {
      await addFoodItemRepository.addFoodItem(
        data: event.addFoodItemData,
      );
      if (addFoodItemRepository.message == 'Food Category Added Successfully') {
        emit(AddFoodItemSuccessState(
          addFoodItemRepository.foodCategory,
          addFoodItemRepository.message,
        ));
      } else {
        emit(AddFoodItemFailureState(
          addFoodItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddFoodItemExceptionState(
        addFoodItemRepository.message,
      ));
    }
  }
}
