part of 'get_coupon_bloc.dart';

abstract class GetCouponsState extends Equatable {
  const GetCouponsState();

  @override
  List<Object> get props => [];
}

class GetCouponsInitialState extends GetCouponsState {}

class GetCouponsLoadingState extends GetCouponsState {
  GetCouponsLoadingState();
}

class GetCouponsLoadingItemState extends GetCouponsState {
  GetCouponsLoadingItemState();
}

class GetCouponsSuccessState extends GetCouponsState {
  final List<Coupon> couponList;
  final String message;

  GetCouponsSuccessState(
    this.couponList,
    this.message,
  );
}

class GetCouponsFailedState extends GetCouponsState {
  final List<Coupon> couponList;
  final String message;

  GetCouponsFailedState(
    this.couponList,
    this.message,
  );
}

class GetCouponsExceptionState extends GetCouponsState {
  final List<Coupon> couponList;
  final String message;

  GetCouponsExceptionState(
    this.couponList,
    this.message,
  );
}
