part of 'get_delivery_charges_bloc.dart';

abstract class GetDeliveryChargesEvent extends Equatable {
  const GetDeliveryChargesEvent();

  @override
  List<Object> get props => [];
}

class GetDeliveryChargesDataEvent extends GetDeliveryChargesEvent {
  GetDeliveryChargesDataEvent();
}

class GetDeliveryChargesDeleteEvent extends GetDeliveryChargesEvent {
  final Map<String, dynamic> deiberyCharges;

  GetDeliveryChargesDeleteEvent({
    required this.deiberyCharges,
  });
}

class UpdateDeliveryChargesEvent extends GetDeliveryChargesEvent {
  final Map<String, dynamic> data;

  UpdateDeliveryChargesEvent({
    required this.data,
  });
}

class GetDeliveryChargesDeleteAllEvent extends GetDeliveryChargesEvent {
  final List<Map<String, dynamic>> deliveryChargesList;

  GetDeliveryChargesDeleteAllEvent({
    required this.deliveryChargesList,
  });
}
