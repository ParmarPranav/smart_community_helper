import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_category.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_liquor_category_event.dart';
part 'edit_liquor_category_repository.dart';
part 'edit_liquor_category_state.dart';

class EditLiquorCategoryBloc extends Bloc<EditLiquorCategoryEvent, EditLiquorCategoryState> {
  EditLiquorCategoryRepository editLiquorCategoryRepository = EditLiquorCategoryRepository();

  EditLiquorCategoryBloc() : super(EditLiquorCategoryInitialState()) {
    on<EditLiquorCategoryAddEvent>(_editLiquorCategoryAddEvent);
  }

  void _editLiquorCategoryAddEvent(EditLiquorCategoryAddEvent event, Emitter<EditLiquorCategoryState> emit) async {
    emit(EditLiquorCategoryLoadingState());
    try {
      await editLiquorCategoryRepository.editLiquorCategory(
        data: event.editLiquorCategoryData,
      );
      if (editLiquorCategoryRepository.message == 'Liquor Category Updated Successfully') {
        emit(EditLiquorCategorySuccessState(
          editLiquorCategoryRepository.liquorCategory,
          editLiquorCategoryRepository.message,
        ));
      } else {
        emit(EditLiquorCategoryFailureState(
          editLiquorCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditLiquorCategoryExceptionState(
        editLiquorCategoryRepository.message,
      ));
    }
  }
}
