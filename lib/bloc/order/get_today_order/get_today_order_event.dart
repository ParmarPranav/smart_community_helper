part of 'get_today_order_bloc.dart';

abstract class GetTodayOrderEvent extends Equatable {
  const GetTodayOrderEvent();

  @override
  List<Object> get props => [];
}

class GetTodayOrderDataEvent extends GetTodayOrderEvent {
  final Map<String, dynamic> data;

  GetTodayOrderDataEvent({
    required this.data
});
}

class GetTodayOrderDeleteEvent extends GetTodayOrderEvent {
  final Map<String, dynamic> emailId;

  GetTodayOrderDeleteEvent({
    required this.emailId,
  });
}

class GetTodayOrderDeleteAllEvent extends GetTodayOrderEvent {
  final List<Map<String, dynamic>> emailIdList;

  GetTodayOrderDeleteAllEvent({
    required this.emailIdList,
  });
}
