import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'add_food_category_event.dart';

part 'add_food_category_repository.dart';

part 'add_food_category_state.dart';

class AddFoodCategoryBloc extends Bloc<AddFoodCategoryEvent, AddFoodCategoryState> {
  AddFoodCategoryRepository addFoodCategoryRepository = AddFoodCategoryRepository();

  AddFoodCategoryBloc() : super(AddFoodCategoryInitialState()) {
    on<AddFoodCategoryAddEvent>(_addFoodCategoryAddEvent);
  }

  void _addFoodCategoryAddEvent(AddFoodCategoryAddEvent event, Emitter<AddFoodCategoryState> emit) async {
    emit(AddFoodCategoryLoadingState());
    try {
      await addFoodCategoryRepository.addFoodCategory(
        data: event.addFoodCategoryData,
      );
      if (addFoodCategoryRepository.message == 'Food Category Added Successfully') {
        emit(AddFoodCategorySuccessState(
          addFoodCategoryRepository.foodCategory,
          addFoodCategoryRepository.message,
        ));
      } else {
        emit(AddFoodCategoryFailureState(
          addFoodCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddFoodCategoryExceptionState(
        addFoodCategoryRepository.message,
      ));
    }
  }
}
