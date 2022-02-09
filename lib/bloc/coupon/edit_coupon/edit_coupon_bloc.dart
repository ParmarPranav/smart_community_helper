import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/coupon.dart';

part 'edit_coupon_event.dart';

part 'edit_coupon_repository.dart';

part 'edit_coupon_state.dart';

class EditCouponBloc extends Bloc<EditCouponEvent, EditCouponState> {
  EditCouponRepository editCouponRepository = EditCouponRepository();

  EditCouponBloc() : super(EditCouponInitialState()) {
    on<EditCouponAddEvent>(_editCouponAddEvent);
  }

  void _editCouponAddEvent(EditCouponAddEvent event, Emitter<EditCouponState> emit) async {
    emit(EditCouponLoadingState());
    try {
      await editCouponRepository.editCoupon(
        data: event.editCouponData,
      );
      if (editCouponRepository.message == 'Coupon Updated Successfully') {
        emit(EditCouponSuccessState(
          editCouponRepository.coupon,
          editCouponRepository.message,
        ));
      } else {
        emit(EditCouponFailureState(
          editCouponRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditCouponExceptionState(
        editCouponRepository.message,
      ));
    }
  }
}
