part of 'add_delivery_charges_blocs.dart';

abstract class AddDeliveryChargesEvent extends Equatable {
  AddDeliveryChargesEvent();

  @override
  List<Object> get props => [];
}

class AddDeliveryChargesAddEvent extends AddDeliveryChargesEvent {
  final Map<String, dynamic> addDeliveryChargesData;

  AddDeliveryChargesAddEvent({
    required this.addDeliveryChargesData,
  });
}
