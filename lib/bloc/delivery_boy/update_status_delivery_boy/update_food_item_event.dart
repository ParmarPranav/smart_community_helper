part of 'update_delivery_boy_bloc.dart';

abstract class UpdateDeliveryBoyEvent extends Equatable {
  UpdateDeliveryBoyEvent();

  @override
  List<Object> get props => [];
}

class UpdateDrivingLicenseEvent extends UpdateDeliveryBoyEvent {
  final Map<String, dynamic> editDeliveryBoyData;

  UpdateDrivingLicenseEvent({
    required this.editDeliveryBoyData,
  });
}

class UpdateLiquorLicenseEvent extends UpdateDeliveryBoyEvent {
  final Map<String, dynamic> editDeliveryBoyData;

  UpdateLiquorLicenseEvent({
    required this.editDeliveryBoyData,
  });
}

class UpdateVehicleCertificateEvent extends UpdateDeliveryBoyEvent {
  final Map<String, dynamic> editDeliveryBoyData;

  UpdateVehicleCertificateEvent({
    required this.editDeliveryBoyData,
  });
}