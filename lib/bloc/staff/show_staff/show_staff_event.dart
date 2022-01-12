part of 'show_staff_bloc.dart';
abstract class ShowStaffEvent extends Equatable {
  const ShowStaffEvent();

  @override
  List<Object> get props => [];
}

class ShowStaffDataEvent extends ShowStaffEvent {
  ShowStaffDataEvent();
}

class ShowStaffDeleteEvent extends ShowStaffEvent {
  final String emailId;

  ShowStaffDeleteEvent({
    required this.emailId,
  });
}

class ShowStaffDeleteAllEvent extends ShowStaffEvent {
  final List<Map<String, dynamic>> emailIdList;

  ShowStaffDeleteAllEvent({
    required this.emailIdList,
  });
}
