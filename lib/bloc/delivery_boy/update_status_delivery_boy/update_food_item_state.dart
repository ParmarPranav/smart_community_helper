part of 'update_delivery_boy_bloc.dart';

abstract class UpdateDeliveryBoyState extends Equatable {
  const UpdateDeliveryBoyState();

  @override
  List<Object> get props => [];
}

class UpdateDeliveryBoyInitialState extends UpdateDeliveryBoyState {}

class UpdateDeliveryBoyLoadingState extends UpdateDeliveryBoyState {
  UpdateDeliveryBoyLoadingState();
}

class UpdateDeliveryBoySuccessState extends UpdateDeliveryBoyState {
  final Vendor? deliveryBoy;
  final String message;

  UpdateDeliveryBoySuccessState(
    this.deliveryBoy,
    this.message,
  );
}

class UpdateDeliveryBoyFailureState extends UpdateDeliveryBoyState {
  final String message;

  UpdateDeliveryBoyFailureState(
    this.message,
  );
}

class UpdateDeliveryBoyExceptionState extends UpdateDeliveryBoyState {
  final String message;

  UpdateDeliveryBoyExceptionState(
    this.message,
  );
}
