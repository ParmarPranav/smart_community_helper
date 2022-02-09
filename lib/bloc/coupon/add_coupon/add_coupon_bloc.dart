import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/coupon.dart';

part 'add_coupon_event.dart';

part 'add_coupon_repository.dart';

part 'add_coupon_state.dart';

class AddCouponBloc extends Bloc<AddCouponEvent, AddCouponState> {
  AddCouponRepository addCouponRepository = AddCouponRepository();

  AddCouponBloc() : super(AddCouponInitialState()) {
    on<AddCouponAddEvent>(_addCouponAddEvent);
  }

  void _addCouponAddEvent(AddCouponAddEvent event, Emitter<AddCouponState> emit) async {
    emit(AddCouponLoadingState());
    try {
      await addCouponRepository.addCoupon(
        data: event.addCouponData,
      );
      if (addCouponRepository.message == 'Coupon Added Successfully') {
        emit(AddCouponSuccessState(
          addCouponRepository.coupon,
          addCouponRepository.message,
        ));
      } else {
        emit(AddCouponFailureState(
          addCouponRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddCouponExceptionState(
        addCouponRepository.message,
      ));
    }
  }
}
