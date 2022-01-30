import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_items.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_liquor_item_event.dart';
part 'get_liquor_item_repository.dart';
part 'get_liquor_item_state.dart';

class GetLiquorItemBloc extends Bloc<GetLiquorItemEvent, GetLiquorItemState> {
  GetLiquorItemRepository getLiquorItemRepository = GetLiquorItemRepository();

  GetLiquorItemBloc() : super(GetLiquorItemInitialState()) {
    on<GetLiquorItemDataEvent>(_getLiquorItemDataEvent);
    on<GetLiquorItemDeleteEvent>(_getLiquorItemDeleteEvent);
    on<GetLiquorItemDeleteAllEvent>(_getLiquorItemDeleteAllEvent);
  }

  void _getLiquorItemDataEvent(GetLiquorItemDataEvent event, Emitter<GetLiquorItemState> emit) async {
    emit(GetLiquorItemLoadingState());
    try {
      await getLiquorItemRepository.getLiquorItemList(event.data);
      if (getLiquorItemRepository.message == 'Liquor Items Fetched Successfully') {
        emit(GetLiquorItemSuccessState(
          getLiquorItemRepository.liquorItemList,
          getLiquorItemRepository.message,
        ));
      } else {
        emit(GetLiquorItemFailedState(
          getLiquorItemRepository.liquorItemList,
          getLiquorItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorItemExceptionState(
        getLiquorItemRepository.liquorItemList,
        getLiquorItemRepository.message,
      ));
    }
  }


  void _getLiquorItemDeleteEvent(GetLiquorItemDeleteEvent event, Emitter<GetLiquorItemState> emit) async {
    emit(GetLiquorItemLoadingItemState());
    try {
      await getLiquorItemRepository.deleteLiquorItem(event.data);
      if (getLiquorItemRepository.message == 'Liquor Item Deleted Successfully') {
        emit(GetLiquorItemSuccessState(
          getLiquorItemRepository.liquorItemList,
          getLiquorItemRepository.message,
        ));
      } else {
        emit(GetLiquorItemFailedState(
          getLiquorItemRepository.liquorItemList,
          getLiquorItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorItemExceptionState(
        getLiquorItemRepository.liquorItemList,
        getLiquorItemRepository.message,
      ));
    }
  }

  void _getLiquorItemDeleteAllEvent(GetLiquorItemDeleteAllEvent event, Emitter<GetLiquorItemState> emit) async {
    emit(GetLiquorItemLoadingItemState());
    try {
      await getLiquorItemRepository.deleteAllLiquorItem(event.idList);
      if (getLiquorItemRepository.message == 'All Liquor Item Deleted Successfully') {
        emit(GetLiquorItemSuccessState(
          getLiquorItemRepository.liquorItemList,
          getLiquorItemRepository.message,
        ));
      } else {
        emit(GetLiquorItemFailedState(
          getLiquorItemRepository.liquorItemList,
          getLiquorItemRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorItemExceptionState(
        getLiquorItemRepository.liquorItemList,
        getLiquorItemRepository.message,
      ));
    }
  }
}
