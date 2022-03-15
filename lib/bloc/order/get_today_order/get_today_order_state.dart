part of 'get_today_order_bloc.dart';


abstract class GetTodayOrderState extends Equatable {
  const GetTodayOrderState();

  @override
  List<Object> get props => [];
}

class GetTodayOrderInitialState extends GetTodayOrderState {}

class GetTodayOrderLoadingState extends GetTodayOrderState {
  GetTodayOrderLoadingState();
}

class GetTodayOrderLoadingItemState extends GetTodayOrderState {
  GetTodayOrderLoadingItemState();
}

class GetTodayOrderSuccessState extends GetTodayOrderState {
  final List<Order> orderList;
  final String message;

  GetTodayOrderSuccessState(
    this.orderList,
    this.message,
  );
}

class GetTodayOrderFailedState extends GetTodayOrderState {
  final List<Order> orderList;
  final String message;

  GetTodayOrderFailedState(
    this.orderList,
    this.message,
  );
}

class GetTodayOrderExceptionState extends GetTodayOrderState {
  final List<Order> orderList;
  final String message;

  GetTodayOrderExceptionState(
    this.orderList,
    this.message,
  );
}
