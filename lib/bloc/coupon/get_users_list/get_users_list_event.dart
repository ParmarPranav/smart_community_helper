part of 'get_users_list_bloc.dart';

abstract class GetUsersListEvent extends Equatable {
  const GetUsersListEvent();

  @override
  List<Object> get props => [];
}

class GetUsersListDataEvent extends GetUsersListEvent {
  GetUsersListDataEvent();
}
