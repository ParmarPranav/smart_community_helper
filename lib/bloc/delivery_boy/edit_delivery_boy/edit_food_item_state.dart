part of 'edit_delivery_boy_bloc.dart';

abstract class EditDeliveryBoyState extends Equatable {
  const EditDeliveryBoyState();

  @override
  List<Object> get props => [];
}

class EditDeliveryBoyInitialState extends EditDeliveryBoyState {}

class EditDeliveryBoyLoadingState extends EditDeliveryBoyState {
  EditDeliveryBoyLoadingState();
}

class EditDeliveryBoySuccessState extends EditDeliveryBoyState {
  final DeliveryBoy? deliveryBoy;
  final String message;

  EditDeliveryBoySuccessState(
    this.deliveryBoy,
    this.message,
  );
}

class EditDeliveryBoyFailureState extends EditDeliveryBoyState {
  final String message;

  EditDeliveryBoyFailureState(
    this.message,
  );
}

class EditDeliveryBoyExceptionState extends EditDeliveryBoyState {
  final String message;

  EditDeliveryBoyExceptionState(
    this.message,
  );
}
