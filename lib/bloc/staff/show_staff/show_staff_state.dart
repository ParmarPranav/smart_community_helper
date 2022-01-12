part of 'show_staff_bloc.dart';

abstract class ShowStaffState extends Equatable {
  const ShowStaffState();

  @override
  List<Object> get props => [];
}

class ShowStaffInitialState extends ShowStaffState {}

class ShowStaffLoadingState extends ShowStaffState {
  ShowStaffLoadingState();
}

class ShowStaffSuccessState extends ShowStaffState {
  final List<AdminDetails> staffList;
  final String message;

  ShowStaffSuccessState(
    this.staffList,
    this.message,
  );
}

class ShowStaffFailedState extends ShowStaffState {
  final List<AdminDetails> staffList;
  final String message;

  ShowStaffFailedState(
    this.staffList,
    this.message,
  );
}

class ShowStaffExceptionState extends ShowStaffState {
  final List<AdminDetails> staffList;
  final String message;

  ShowStaffExceptionState(
    this.staffList,
    this.message,
  );
}
