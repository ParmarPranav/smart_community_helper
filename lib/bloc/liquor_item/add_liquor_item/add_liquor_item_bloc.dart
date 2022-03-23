import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/models/liquor_item.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'add_liquor_item_event.dart';

part 'add_liquor_item_repository.dart';

part 'add_liquor_item_state.dart';

class AddLiquorItemBloc extends Bloc<AddLiquorItemEvent, AddLiquorItemState> {
  AddLiquorItemRepository addLiquorItemRepository = AddLiquorItemRepository();

  AddLiquorItemBloc() : super(AddLiquorItemInitialState()) {
    on<AddLiquorItemAddEvent>(_addLiquorItemAddEvent);
  }

  void _addLiquorItemAddEvent(AddLiquorItemAddEvent event, Emitter<AddLiquorItemState> emit) async {
    emit(AddLiquorItemLoadingState());
    try {
      await addLiquorItemRepository.addLiquorItem(
        data: event.addLiquorItemData,
      );
      if (addLiquorItemRepository.message == 'Liquor Item Added Successfully') {
        emit(AddLiquorItemSuccessState(
          addLiquorItemRepository.liquorItem,
          addLiquorItemRepository.message,
        ));
      } else {
        emit(AddLiquorItemFailureState(
          addLiquorItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddLiquorItemExceptionState(
        addLiquorItemRepository.message,
      ));
    }
  }
}
