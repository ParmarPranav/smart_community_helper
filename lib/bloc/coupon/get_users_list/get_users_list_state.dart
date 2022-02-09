part of 'get_users_list_bloc.dart';

abstract class GetUsersListState extends Equatable {
  const GetUsersListState();

  @override
  List<Object> get props => [];
}

class GetUsersListInitialState extends GetUsersListState {}

class GetUsersListLoadingState extends GetUsersListState {
  GetUsersListLoadingState();
}

class GetUsersListLoadingItemState extends GetUsersListState {
  GetUsersListLoadingItemState();
}

class GetUsersListSuccessState extends GetUsersListState {
  final List<Users> usersList;
  final String message;

  GetUsersListSuccessState(
    this.usersList,
    this.message,
  );
}

class GetUsersListFailedState extends GetUsersListState {
  final List<Users> usersList;
  final String message;

  GetUsersListFailedState(
    this.usersList,
    this.message,
  );
}

class GetUsersListExceptionState extends GetUsersListState {
  final List<Users> usersList;
  final String message;

  GetUsersListExceptionState(
    this.usersList,
    this.message,
  );
}
