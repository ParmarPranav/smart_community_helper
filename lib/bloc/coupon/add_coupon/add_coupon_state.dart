part of 'add_coupon_bloc.dart';

abstract class AddCouponState extends Equatable {
  const AddCouponState();

  @override
  List<Object> get props => [];
}

class AddCouponInitialState extends AddCouponState {}

class AddCouponLoadingState extends AddCouponState {
  AddCouponLoadingState();
}

class AddCouponSuccessState extends AddCouponState {
  final Coupon? coupon;
  final String message;

  AddCouponSuccessState(
    this.coupon,
    this.message,
  );
}

class AddCouponFailureState extends AddCouponState {
  final String message;

  AddCouponFailureState(
    this.message,
  );
}

class AddCouponExceptionState extends AddCouponState {
  final String message;

  AddCouponExceptionState(
    this.message,
  );
}
