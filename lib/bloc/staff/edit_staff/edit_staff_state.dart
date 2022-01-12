part of 'edit_staff_bloc.dart';

abstract class EditStaffState extends Equatable {
  const EditStaffState();

  @override
  List<Object> get props => [];
}

class EditStaffInitialState extends EditStaffState {}

class EditStaffLoadingState extends EditStaffState {}

class EditStaffSuccessState extends EditStaffState {
  final AdminDetails? adminDetails;
  final String message;

  EditStaffSuccessState(this.adminDetails, this.message);
}

class EditStaffFailureState extends EditStaffState {
  final String message;

  EditStaffFailureState(this.message);
}

class EditStaffExceptionState extends EditStaffState {
  final String message;

  EditStaffExceptionState(this.message);
}
