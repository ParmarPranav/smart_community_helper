part of 'edit_delivery_charges_bloc.dart';

abstract class EditDeliveryChargesEvent extends Equatable {
  EditDeliveryChargesEvent();

  @override
  List<Object> get props => [];
}

class EditDeliveryChargesEditEvent extends EditDeliveryChargesEvent {
  final Map<String, dynamic> editDeliveryChargesData;

  EditDeliveryChargesEditEvent({
    required this.editDeliveryChargesData,
  });
}
