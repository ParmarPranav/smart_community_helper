part of 'edit_coupon_bloc.dart';

abstract class EditCouponState extends Equatable {
  const EditCouponState();

  @override
  List<Object> get props => [];
}

class EditCouponInitialState extends EditCouponState {}

class EditCouponLoadingState extends EditCouponState {
  EditCouponLoadingState();
}

class EditCouponSuccessState extends EditCouponState {
  final Coupon? coupon;
  final String message;

  EditCouponSuccessState(
    this.coupon,
    this.message,
  );
}

class EditCouponFailureState extends EditCouponState {
  final String message;

  EditCouponFailureState(
    this.message,
  );
}

class EditCouponExceptionState extends EditCouponState {
  final String message;

  EditCouponExceptionState(
    this.message,
  );
}
