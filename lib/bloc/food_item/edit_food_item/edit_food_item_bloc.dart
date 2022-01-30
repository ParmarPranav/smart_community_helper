import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_food_item_event.dart';
part 'edit_food_item_repository.dart';
part 'edit_food_item_state.dart';

class EditFoodItemBloc extends Bloc<EditFoodItemEvent, EditFoodItemState> {
  EditFoodItemRepository editFoodItemRepository = EditFoodItemRepository();

  EditFoodItemBloc() : super(EditFoodItemInitialState()) {
    on<EditFoodItemAddEvent>(_editFoodItemAddEvent);
  }

  void _editFoodItemAddEvent(EditFoodItemAddEvent event, Emitter<EditFoodItemState> emit) async {
    emit(EditFoodItemLoadingState());
    try {
      await editFoodItemRepository.editFoodItem(
        data: event.editFoodItemData,
      );
      if (editFoodItemRepository.message == 'Food Item Updated Successfully') {
        emit(EditFoodItemSuccessState(
          editFoodItemRepository.foodItem,
          editFoodItemRepository.message,
        ));
      } else {
        emit(EditFoodItemFailureState(
          editFoodItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditFoodItemExceptionState(
        editFoodItemRepository.message,
      ));
    }
  }
}
