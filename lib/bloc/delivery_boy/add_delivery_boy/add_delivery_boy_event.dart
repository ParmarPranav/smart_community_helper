part of 'add_delivery_boy_blocs.dart';

abstract class AddDeliveryBoyEvent extends Equatable {
  AddDeliveryBoyEvent();

  @override
  List<Object> get props => [];
}

class AddDeliveryBoyAddEvent extends AddDeliveryBoyEvent {
  final Map<String, dynamic> addDeliveryBoyData;

  AddDeliveryBoyAddEvent({
    required this.addDeliveryBoyData,
  });
}
