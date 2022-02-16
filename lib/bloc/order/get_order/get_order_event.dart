part of 'get_order_bloc.dart';

abstract class GetOrderEvent extends Equatable {
  const GetOrderEvent();

  @override
  List<Object> get props => [];
}

class GetOrderDataEvent extends GetOrderEvent {
  final Map<String, dynamic> data;

  GetOrderDataEvent({
    required this.data
});
}

class GetOrderDeleteEvent extends GetOrderEvent {
  final Map<String, dynamic> emailId;

  GetOrderDeleteEvent({
    required this.emailId,
  });
}

class GetOrderDeleteAllEvent extends GetOrderEvent {
  final List<Map<String, dynamic>> emailIdList;

  GetOrderDeleteAllEvent({
    required this.emailIdList,
  });
}
