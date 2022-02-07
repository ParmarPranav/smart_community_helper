part of 'edit_delivery_boy_bloc.dart';

abstract class EditDeliveryBoyEvent extends Equatable {
  EditDeliveryBoyEvent();

  @override
  List<Object> get props => [];
}

class EditDeliveryBoyAddEvent extends EditDeliveryBoyEvent {
  final Map<String, dynamic> editDeliveryBoyData;

  EditDeliveryBoyAddEvent({
    required this.editDeliveryBoyData,
  });
}
