part of 'get_delivery_boy_bloc.dart';

abstract class GetDeliveryBoyState extends Equatable {
  const GetDeliveryBoyState();

  @override
  List<Object> get props => [];
}

class GetDeliveryBoyInitialState extends GetDeliveryBoyState {}

class GetDeliveryBoyLoadingState extends GetDeliveryBoyState {
  GetDeliveryBoyLoadingState();
}

class GetDeliveryBoyLoadingItemState extends GetDeliveryBoyState {
  GetDeliveryBoyLoadingItemState();
}

class GetDeliveryBoySuccessState extends GetDeliveryBoyState {
  final List<DeliveryBoy> deliveryBoyList;
  final String message;

  GetDeliveryBoySuccessState(
    this.deliveryBoyList,
    this.message,
  );
}

class GetDeliveryBoyFailedState extends GetDeliveryBoyState {
  final List<DeliveryBoy> deliveryBoyList;
  final String message;

  GetDeliveryBoyFailedState(
    this.deliveryBoyList,
    this.message,
  );
}

class GetDeliveryBoyExceptionState extends GetDeliveryBoyState {
  final List<DeliveryBoy> deliveryBoyList;
  final String message;

  GetDeliveryBoyExceptionState(
    this.deliveryBoyList,
    this.message,
  );
}
