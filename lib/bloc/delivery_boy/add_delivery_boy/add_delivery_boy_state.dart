part of 'add_delivery_boy_blocs.dart';

abstract class AddDeliveryBoyState extends Equatable {
  const AddDeliveryBoyState();

  @override
  List<Object> get props => [];
}

class AddDeliveryBoyInitialState extends AddDeliveryBoyState {}

class AddDeliveryBoyLoadingState extends AddDeliveryBoyState {
  AddDeliveryBoyLoadingState();
}

class AddDeliveryBoySuccessState extends AddDeliveryBoyState {
  final Vendor? deliveryBoy;
  final String message;

  AddDeliveryBoySuccessState(
    this.deliveryBoy,
    this.message,
  );
}

class AddDeliveryBoyFailureState extends AddDeliveryBoyState {
  final String message;

  AddDeliveryBoyFailureState(
    this.message,
  );
}

class AddDeliveryBoyExceptionState extends AddDeliveryBoyState {
  final String message;

  AddDeliveryBoyExceptionState(
    this.message,
  );
}
