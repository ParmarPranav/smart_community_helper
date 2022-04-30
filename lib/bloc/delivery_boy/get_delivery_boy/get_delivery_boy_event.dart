part of 'get_delivery_boy_bloc.dart';

abstract class GetDeliveryBoyEvent extends Equatable {
  const GetDeliveryBoyEvent();

  @override
  List<Object> get props => [];
}

class GetDeliveryBoyDataEvent extends GetDeliveryBoyEvent {

}

class GetDeliveryBoyDeleteEvent extends GetDeliveryBoyEvent {
  final Map<String, dynamic> emailId;

  GetDeliveryBoyDeleteEvent({
    required this.emailId,
  });
}

class GetDeliveryBoyDeleteAllEvent extends GetDeliveryBoyEvent {
  final List<Map<String, dynamic>> emailIdList;

  GetDeliveryBoyDeleteAllEvent({
    required this.emailIdList,
  });
}
