part of 'add_staff_bloc.dart';

abstract class AddStaffState extends Equatable {
  const AddStaffState();

  @override
  List<Object> get props => [];
}

class AddStaffInitialState extends AddStaffState {}

class AddStaffLoadingState extends AddStaffState {}

class AddStaffSuccessState extends AddStaffState {
  final AdminDetails? staff;
  final String message;

  AddStaffSuccessState(
    this.staff,
    this.message,
  );
}

class AddStaffFailureState extends AddStaffState {
  final String message;

  AddStaffFailureState(this.message);
}

class AddStaffExceptionState extends AddStaffState {
  final String message;

  AddStaffExceptionState(this.message);
}
