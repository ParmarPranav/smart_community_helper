import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/coupon.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

part 'get_coupon_event.dart';

part 'get_coupon_repository.dart';

part 'get_coupon_state.dart';

class GetCouponsBloc extends Bloc<GetCouponsEvent, GetCouponsState> {
  GetCouponsRepository getCouponsRepository = GetCouponsRepository();

  GetCouponsBloc() : super(GetCouponsInitialState()) {
    on<GetCouponsDataEvent>(_getCouponsDataEvent);
    on<GetCouponsUpdateStatusEvent>(_getCouponUpdateStatusEvent);
    on<GetCouponsDeleteEvent>(_getCouponsDeleteEvent);
    on<GetCouponsDeleteAllEvent>(_getCouponsDeleteAllEvent);
  }

  void _getCouponsDataEvent(GetCouponsDataEvent event, Emitter<GetCouponsState> emit) async {
    emit(GetCouponsLoadingState());
    try {
      await getCouponsRepository.getCouponList();
      if (getCouponsRepository.message == 'Coupons Fetched Successfully') {
        emit(GetCouponsSuccessState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      } else {
        emit(GetCouponsFailedState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCouponsExceptionState(
        getCouponsRepository.couponList,
        getCouponsRepository.message,
      ));
    }
  }

  void _getCouponUpdateStatusEvent(GetCouponsUpdateStatusEvent event, Emitter<GetCouponsState> emit) async {
    emit(GetCouponsLoadingItemState());
    try {
      await getCouponsRepository.updateStatusCoupon(event.data);
      if (getCouponsRepository.message == 'Coupon Status Updated Successfully') {
        emit(GetCouponsSuccessState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      } else {
        emit(GetCouponsFailedState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCouponsExceptionState(
        getCouponsRepository.couponList,
        getCouponsRepository.message,
      ));
    }
  }

  void _getCouponsDeleteEvent(GetCouponsDeleteEvent event, Emitter<GetCouponsState> emit) async {
    emit(GetCouponsLoadingItemState());
    try {
      await getCouponsRepository.deleteCoupon(event.id);
      if (getCouponsRepository.message == 'Coupon Deleted Successfully') {
        emit(GetCouponsSuccessState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      } else {
        emit(GetCouponsFailedState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCouponsExceptionState(
        getCouponsRepository.couponList,
        getCouponsRepository.message,
      ));
    }
  }

  void _getCouponsDeleteAllEvent(GetCouponsDeleteAllEvent event, Emitter<GetCouponsState> emit) async {
    emit(GetCouponsLoadingItemState());
    try {
      await getCouponsRepository.deleteAllCoupon(event.idList);
      if (getCouponsRepository.message == 'All Coupon Deleted Successfully') {
        emit(GetCouponsSuccessState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      } else {
        emit(GetCouponsFailedState(
          getCouponsRepository.couponList,
          getCouponsRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCouponsExceptionState(
        getCouponsRepository.couponList,
        getCouponsRepository.message,
      ));
    }
  }
}
