part of 'get_delivery_charges_bloc.dart';

abstract class GetDeliveryChargesState extends Equatable {
  const GetDeliveryChargesState();

  @override
  List<Object> get props => [];
}

class GetDeliveryChargesInitialState extends GetDeliveryChargesState {}

class GetDeliveryChargesLoadingState extends GetDeliveryChargesState {
  GetDeliveryChargesLoadingState();
}

class GetDeliveryChargesLoadingItemState extends GetDeliveryChargesState {
  GetDeliveryChargesLoadingItemState();
}

class GetDeliveryChargesSuccessState extends GetDeliveryChargesState {
  final List<DeliveryCharges> deliveryChargesList;
  final String message;

  GetDeliveryChargesSuccessState(
    this.deliveryChargesList,
    this.message,
  );
}

class GetDeliveryChargesFailedState extends GetDeliveryChargesState {
  final List<DeliveryCharges> deliveryChargesList;
  final String message;

  GetDeliveryChargesFailedState(
    this.deliveryChargesList,
    this.message,
  );
}

class GetDeliveryChargesExceptionState extends GetDeliveryChargesState {
  final List<DeliveryCharges> deliveryChargesList;
  final String message;

  GetDeliveryChargesExceptionState(
    this.deliveryChargesList,
    this.message,
  );
}
