import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_food_category_event.dart';

part 'edit_food_category_repository.dart';

part 'edit_food_category_state.dart';

class EditFoodCategoryBloc extends Bloc<EditFoodCategoryEvent, EditFoodCategoryState> {
  EditFoodCategoryRepository editFoodCategoryRepository = EditFoodCategoryRepository();

  EditFoodCategoryBloc() : super(EditFoodCategoryInitialState()) {
    on<EditFoodCategoryAddEvent>(_editFoodCategoryAddEvent);
  }

  void _editFoodCategoryAddEvent(EditFoodCategoryAddEvent event, Emitter<EditFoodCategoryState> emit) async {
    emit(EditFoodCategoryLoadingState());
    try {
      await editFoodCategoryRepository.editFoodCategory(
        data: event.editFoodCategoryData,
      );
      if (editFoodCategoryRepository.message == 'Food Category Updated Successfully') {
        emit(EditFoodCategorySuccessState(
          editFoodCategoryRepository.foodCategory,
          editFoodCategoryRepository.message,
        ));
      } else {
        emit(EditFoodCategoryFailureState(
          editFoodCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditFoodCategoryExceptionState(
        editFoodCategoryRepository.message,
      ));
    }
  }
}
