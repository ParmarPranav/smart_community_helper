part of 'add_coupon_bloc.dart';

abstract class AddCouponEvent extends Equatable {
  AddCouponEvent();

  @override
  List<Object> get props => [];
}

class AddCouponAddEvent extends AddCouponEvent {
  final Map<String, dynamic> addCouponData;

  AddCouponAddEvent({
    required this.addCouponData,
  });
}
