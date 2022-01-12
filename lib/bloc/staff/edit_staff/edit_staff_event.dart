part of 'edit_staff_bloc.dart';

abstract class EditStaffEvent extends Equatable {
  EditStaffEvent();

  @override
  List<Object> get props => [];
}

class EditStaffRegisterEvent extends EditStaffEvent {
  final Map<String, dynamic> staffData;

  EditStaffRegisterEvent({
    required this.staffData,
  });
}
