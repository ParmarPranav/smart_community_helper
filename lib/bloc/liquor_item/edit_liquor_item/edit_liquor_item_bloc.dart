import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/models/liquor_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'edit_liquor_item_event.dart';
part 'edit_liquor_item_repository.dart';
part 'edit_liquor_item_state.dart';

class EditLiquorItemBloc extends Bloc<EditLiquorItemEvent, EditLiquorItemState> {
  EditLiquorItemRepository editLiquorItemRepository = EditLiquorItemRepository();

  EditLiquorItemBloc() : super(EditLiquorItemInitialState()) {
    on<EditLiquorItemAddEvent>(_editLiquorItemAddEvent);
  }

  void _editLiquorItemAddEvent(EditLiquorItemAddEvent event, Emitter<EditLiquorItemState> emit) async {
    emit(EditLiquorItemLoadingState());
    try {
      await editLiquorItemRepository.editLiquorItem(
        data: event.editLiquorItemData,
      );
      if (editLiquorItemRepository.message == 'Liquor Item Updated Successfully') {
        emit(EditLiquorItemSuccessState(
          editLiquorItemRepository.liquorItem,
          editLiquorItemRepository.message,
        ));
      } else {
        emit(EditLiquorItemFailureState(
          editLiquorItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditLiquorItemExceptionState(
        editLiquorItemRepository.message,
      ));
    }
  }
}
