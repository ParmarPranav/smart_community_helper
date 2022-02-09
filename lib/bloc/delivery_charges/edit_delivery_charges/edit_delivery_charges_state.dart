part of 'edit_delivery_charges_bloc.dart';

abstract class EditDeliveryChargesState extends Equatable {
  const EditDeliveryChargesState();

  @override
  List<Object> get props => [];
}

class EditDeliveryChargesInitialState extends EditDeliveryChargesState {}

class EditDeliveryChargesLoadingState extends EditDeliveryChargesState {
  EditDeliveryChargesLoadingState();
}

class EditDeliveryChargesSuccessState extends EditDeliveryChargesState {
  final DeliveryCharges? deliveryCharges;
  final String message;

  EditDeliveryChargesSuccessState(
    this.deliveryCharges,
    this.message,
  );
}

class EditDeliveryChargesFailureState extends EditDeliveryChargesState {
  final String message;

  EditDeliveryChargesFailureState(
    this.message,
  );
}

class EditDeliveryChargesExceptionState extends EditDeliveryChargesState {
  final String message;

  EditDeliveryChargesExceptionState(
    this.message,
  );
}
