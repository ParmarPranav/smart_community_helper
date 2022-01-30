import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_category.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

import 'package:http/http.dart' as http;

part 'add_liquor_category_event.dart';

part 'add_liquor_category_repository.dart';

part 'add_liquor_category_state.dart';

class AddLiquorCategoryBloc extends Bloc<AddLiquorCategoryEvent, AddLiquorCategoryState> {
  AddLiquorCategoryRepository addLiquorCategoryRepository = AddLiquorCategoryRepository();

  AddLiquorCategoryBloc() : super(AddLiquorCategoryInitialState()) {
    on<AddLiquorCategoryAddEvent>(_addLiquorCategoryAddEvent);
  }

  void _addLiquorCategoryAddEvent(AddLiquorCategoryAddEvent event, Emitter<AddLiquorCategoryState> emit) async {
    emit(AddLiquorCategoryLoadingState());
    try {
      await addLiquorCategoryRepository.addLiquorCategory(
        data: event.addLiquorCategoryData,
      );
      if (addLiquorCategoryRepository.message == 'Liquor Category Added Successfully') {
        emit(AddLiquorCategorySuccessState(
          addLiquorCategoryRepository.liquorCategory,
          addLiquorCategoryRepository.message,
        ));
      } else {
        emit(AddLiquorCategoryFailureState(
          addLiquorCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddLiquorCategoryExceptionState(
        addLiquorCategoryRepository.message,
      ));
    }
  }
}
