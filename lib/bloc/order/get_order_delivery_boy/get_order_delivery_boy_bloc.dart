import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/order.dart';
import 'get_order_delivery_boy_bloc.dart';
import 'get_order_delivery_boy_bloc.dart';

part 'get_order_delivery_boy_event.dart';
part 'get_order_delivery_boy_repository.dart';
part 'get_order_delivery_boy_state.dart';

class GetOrderDeliveryBoyBloc extends Bloc<GetOrderDeliveryBoyEvent, GetOrderDeliveryBoyState> {

  GetOrderDeliveryBoyRepository getOrderDeliveryBoyRepository = GetOrderDeliveryBoyRepository();

  GetOrderDeliveryBoyBloc() : super(GetOrderDeliveryBoyInitialState()) {
    on<GetOrderDeliveryBoyDataEvent>(_GetOrderDeliveryBoyDataEvent);
   }

  void _GetOrderDeliveryBoyDataEvent(GetOrderDeliveryBoyDataEvent event, Emitter<GetOrderDeliveryBoyState> emit) async {
    emit(GetOrderDeliveryBoyLoadingState());
    try {
      await getOrderDeliveryBoyRepository.getOrderDeliveryBoyList(event.data);
      if (getOrderDeliveryBoyRepository.message == 'Order Fetched Successfully') {
        emit(GetOrderDeliveryBoySuccessState(
          getOrderDeliveryBoyRepository.orderList,
          getOrderDeliveryBoyRepository.message,
        ));
      } else {
        emit(GetOrderDeliveryBoyFailedState(
          getOrderDeliveryBoyRepository.orderList,
          getOrderDeliveryBoyRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetOrderDeliveryBoyExceptionState(
        getOrderDeliveryBoyRepository.orderList,
        getOrderDeliveryBoyRepository.message,
      ));
    }
  }

 
}
