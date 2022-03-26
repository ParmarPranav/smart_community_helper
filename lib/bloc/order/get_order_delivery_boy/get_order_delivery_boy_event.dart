part of 'get_order_delivery_boy_bloc.dart';


abstract class GetOrderDeliveryBoyEvent extends Equatable {
  const GetOrderDeliveryBoyEvent();

  @override
  List<Object> get props => [];
}

class GetOrderDeliveryBoyDataEvent extends GetOrderDeliveryBoyEvent {
  final Map<String, dynamic> data;

  GetOrderDeliveryBoyDataEvent({
    required this.data
});
}

class GetOrderDeliveryBoyDeleteEvent extends GetOrderDeliveryBoyEvent {
  final Map<String, dynamic> emailId;

  GetOrderDeliveryBoyDeleteEvent({
    required this.emailId,
  });
}

class GetOrderDeliveryBoyDeleteAllEvent extends GetOrderDeliveryBoyEvent {
  final List<Map<String, dynamic>> emailIdList;

  GetOrderDeliveryBoyDeleteAllEvent({
    required this.emailIdList,
  });
}
