part of 'edit_coupon_bloc.dart';

abstract class EditCouponEvent extends Equatable {
  EditCouponEvent();

  @override
  List<Object> get props => [];
}

class EditCouponAddEvent extends EditCouponEvent {
  final Map<String, dynamic> editCouponData;

  EditCouponAddEvent({
    required this.editCouponData,
  });
}
