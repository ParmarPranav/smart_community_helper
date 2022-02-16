part of 'get_order_bloc.dart';

abstract class GetOrderState extends Equatable {
  const GetOrderState();

  @override
  List<Object> get props => [];
}

class GetOrderInitialState extends GetOrderState {}

class GetOrderLoadingState extends GetOrderState {
  GetOrderLoadingState();
}

class GetOrderLoadingItemState extends GetOrderState {
  GetOrderLoadingItemState();
}

class GetOrderSuccessState extends GetOrderState {
  final List<Order> orderList;
  final String message;

  GetOrderSuccessState(
    this.orderList,
    this.message,
  );
}

class GetOrderFailedState extends GetOrderState {
  final List<Order> orderList;
  final String message;

  GetOrderFailedState(
    this.orderList,
    this.message,
  );
}

class GetOrderExceptionState extends GetOrderState {
  final List<Order> orderList;
  final String message;

  GetOrderExceptionState(
    this.orderList,
    this.message,
  );
}
