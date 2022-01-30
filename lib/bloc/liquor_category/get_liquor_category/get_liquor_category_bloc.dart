import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_category.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_liquor_category_event.dart';
part 'get_liquor_category_repository.dart';
part 'get_liquor_category_state.dart';

class GetLiquorCategoryBloc extends Bloc<GetLiquorCategoryEvent, GetLiquorCategoryState> {
  GetLiquorCategoryRepository getLiquorCategoryRepository = GetLiquorCategoryRepository();

  GetLiquorCategoryBloc() : super(GetLiquorCategoryInitialState()) {
    on<GetLiquorCategoryDataEvent>(_getLiquorCategoryDataEvent);
    on<GetLiquorCategoryUpdateStatusEvent>(_getLiquorCategoryUpdateStatusEvent);
    on<GetLiquorCategoryDeleteEvent>(_getLiquorCategoryDeleteEvent);
    on<GetLiquorCategoryDeleteAllEvent>(_getLiquorCategoryDeleteAllEvent);
  }

  void _getLiquorCategoryDataEvent(GetLiquorCategoryDataEvent event, Emitter<GetLiquorCategoryState> emit) async {
    emit(GetLiquorCategoryLoadingState());
    try {
      await getLiquorCategoryRepository.getLiquorCategoryList(event.data);
      if (getLiquorCategoryRepository.message == 'Liquor Category Fetched Successfully') {
        emit(GetLiquorCategorySuccessState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      } else {
        emit(GetLiquorCategoryFailedState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorCategoryExceptionState(
        getLiquorCategoryRepository.liquorCategoryList,
        getLiquorCategoryRepository.message,
      ));
    }
  }

  void _getLiquorCategoryUpdateStatusEvent(GetLiquorCategoryUpdateStatusEvent event, Emitter<GetLiquorCategoryState> emit) async {
    emit(GetLiquorCategoryLoadingItemState());
    try {
      await getLiquorCategoryRepository.updateStatusLiquorCategory(event.data);
      if (getLiquorCategoryRepository.message == 'Liquor Category Status Updated Successfully') {
        emit(GetLiquorCategorySuccessState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      } else {
        emit(GetLiquorCategoryFailedState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorCategoryExceptionState(
        getLiquorCategoryRepository.liquorCategoryList,
        getLiquorCategoryRepository.message,
      ));
    }
  }

  void _getLiquorCategoryDeleteEvent(GetLiquorCategoryDeleteEvent event, Emitter<GetLiquorCategoryState> emit) async {
    emit(GetLiquorCategoryLoadingItemState());
    try {
      await getLiquorCategoryRepository.deleteLiquorCategory(event.data);
      if (getLiquorCategoryRepository.message == 'Liquor Category Deleted Successfully') {
        emit(GetLiquorCategorySuccessState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      } else {
        emit(GetLiquorCategoryFailedState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorCategoryExceptionState(
        getLiquorCategoryRepository.liquorCategoryList,
        getLiquorCategoryRepository.message,
      ));
    }
  }

  void _getLiquorCategoryDeleteAllEvent(GetLiquorCategoryDeleteAllEvent event, Emitter<GetLiquorCategoryState> emit) async {
    emit(GetLiquorCategoryLoadingItemState());
    try {
      await getLiquorCategoryRepository.deleteAllLiquorCategory(event.idList);
      if (getLiquorCategoryRepository.message == 'All Liquor Category Deleted Successfully') {
        emit(GetLiquorCategorySuccessState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      } else {
        emit(GetLiquorCategoryFailedState(
          getLiquorCategoryRepository.liquorCategoryList,
          getLiquorCategoryRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetLiquorCategoryExceptionState(
        getLiquorCategoryRepository.liquorCategoryList,
        getLiquorCategoryRepository.message,
      ));
    }
  }
}
