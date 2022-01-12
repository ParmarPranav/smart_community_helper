part of 'add_staff_bloc.dart';

abstract class AddStaffEvent extends Equatable {
  AddStaffEvent();

  @override
  List<Object> get props => [];
}

class AddStaffRegisterEvent extends AddStaffEvent {
  final Map<String, dynamic> staffData;

  AddStaffRegisterEvent({
    required this.staffData,
  });
}
