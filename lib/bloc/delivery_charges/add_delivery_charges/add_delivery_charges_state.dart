part of 'add_delivery_charges_blocs.dart';

abstract class AddDeliveryChargesState extends Equatable {
  const AddDeliveryChargesState();

  @override
  List<Object> get props => [];
}

class AddDeliveryChargesInitialState extends AddDeliveryChargesState {}

class AddDeliveryChargesLoadingState extends AddDeliveryChargesState {
  AddDeliveryChargesLoadingState();
}

class AddDeliveryChargesSuccessState extends AddDeliveryChargesState {
  final DeliveryCharges? deliveryCharges;
  final String message;

  AddDeliveryChargesSuccessState(
    this.deliveryCharges,
    this.message,
  );
}

class AddDeliveryChargesFailureState extends AddDeliveryChargesState {
  final String message;

  AddDeliveryChargesFailureState(
    this.message,
  );
}

class AddDeliveryChargesExceptionState extends AddDeliveryChargesState {
  final String message;

  AddDeliveryChargesExceptionState(
    this.message,
  );
}
