part of 'get_user_bloc.dart';

abstract class GetUsersEvent extends Equatable {
  const GetUsersEvent();

  @override
  List<Object> get props => [];
}

class GetUsersDataEvent extends GetUsersEvent {

}

class GetUsersDeleteEvent extends GetUsersEvent {
  final Map<String, dynamic> user;

  GetUsersDeleteEvent({
    required this.user,
  });
}

class UpdateUsersIsCodEnableEvent extends GetUsersEvent {
  final Map<String, dynamic> data;

  UpdateUsersIsCodEnableEvent({
    required this.data,
  });
}
class UpdateUsersIsBlockEvent extends GetUsersEvent {
  final Map<String, dynamic> data;

  UpdateUsersIsBlockEvent({
    required this.data,
  });
}
class UpdateUsersIsBannedEvent extends GetUsersEvent {
  final Map<String, dynamic> data;

  UpdateUsersIsBannedEvent({
    required this.data,
  });
}

class GetUsersDeleteAllEvent extends GetUsersEvent {
  final List<Map<String, dynamic>> idList;

  GetUsersDeleteAllEvent({
    required this.idList,
  });
}
