import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/order.dart';

part 'get_order_event.dart';
part 'get_order_repository.dart';
part 'get_order_state.dart';

class GetOrderBloc extends Bloc<GetOrderEvent, GetOrderState> {
  GetOrderRepository getOrderRepository = GetOrderRepository();

  GetOrderBloc() : super(GetOrderInitialState()) {
    on<GetOrderDataEvent>(_getOrderDataEvent);
   }

  void _getOrderDataEvent(GetOrderDataEvent event, Emitter<GetOrderState> emit) async {
    emit(GetOrderLoadingState());
    try {
      await getOrderRepository.getOrderList(event.data);
      if (getOrderRepository.message == 'Order Fetched Successfully') {
        emit(GetOrderSuccessState(
          getOrderRepository.orderList,
          getOrderRepository.message,
        ));
      } else {
        emit(GetOrderFailedState(
          getOrderRepository.orderList,
          getOrderRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetOrderExceptionState(
        getOrderRepository.orderList,
        getOrderRepository.message,
      ));
    }
  }

 
}
