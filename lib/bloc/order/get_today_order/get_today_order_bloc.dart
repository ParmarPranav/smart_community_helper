import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/order/get_today_order/get_today_order_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/order.dart';

part 'get_today_order_event.dart';
part 'get_today_order_repository.dart';
part 'get_today_order_state.dart';

class GetTodayOrderBloc extends Bloc<GetTodayOrderEvent, GetTodayOrderState> {
  GetTodayOrderRepository getTodayOrderRepository = GetTodayOrderRepository();

  GetTodayOrderBloc() : super(GetTodayOrderInitialState()) {
    on<GetTodayOrderDataEvent>(_GetTodayOrderDataEvent);
   }

  void _GetTodayOrderDataEvent(GetTodayOrderDataEvent event, Emitter<GetTodayOrderState> emit) async {
    emit(GetTodayOrderLoadingState());
    try {
      await getTodayOrderRepository.getTodayOrderList(event.data);
      if (getTodayOrderRepository.message == 'Order Fetched Successfully') {
        emit(GetTodayOrderSuccessState(
          getTodayOrderRepository.orderList,
          getTodayOrderRepository.message,
        ));
      } else {
        emit(GetTodayOrderFailedState(
          getTodayOrderRepository.orderList,
          getTodayOrderRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetTodayOrderExceptionState(
        getTodayOrderRepository.orderList,
        getTodayOrderRepository.message,
      ));
    }
  }

 
}
