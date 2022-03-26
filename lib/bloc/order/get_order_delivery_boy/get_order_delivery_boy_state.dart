part of 'get_order_delivery_boy_bloc.dart';

abstract class GetOrderDeliveryBoyState extends Equatable {
  const GetOrderDeliveryBoyState();

  @override
  List<Object> get props => [];
}

class GetOrderDeliveryBoyInitialState extends GetOrderDeliveryBoyState {}

class GetOrderDeliveryBoyLoadingState extends GetOrderDeliveryBoyState {
  GetOrderDeliveryBoyLoadingState();
}

class GetOrderDeliveryBoyLoadingItemState extends GetOrderDeliveryBoyState {
  GetOrderDeliveryBoyLoadingItemState();
}

class GetOrderDeliveryBoySuccessState extends GetOrderDeliveryBoyState {
  final List<Order> orderList;
  final String message;

  GetOrderDeliveryBoySuccessState(
    this.orderList,
    this.message,
  );
}

class GetOrderDeliveryBoyFailedState extends GetOrderDeliveryBoyState {
  final List<Order> orderList;
  final String message;

  GetOrderDeliveryBoyFailedState(
    this.orderList,
    this.message,
  );
}

class GetOrderDeliveryBoyExceptionState extends GetOrderDeliveryBoyState {
  final List<Order> orderList;
  final String message;

  GetOrderDeliveryBoyExceptionState(
    this.orderList,
    this.message,
  );
}
