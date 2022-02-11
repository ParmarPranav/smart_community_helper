part of 'get_user_bloc.dart';

abstract class GetUsersState extends Equatable {
  const GetUsersState();

  @override
  List<Object> get props => [];
}

class GetUsersInitialState extends GetUsersState {}

class GetUsersLoadingState extends GetUsersState {
  GetUsersLoadingState();
}

class GetUsersLoadingItemState extends GetUsersState {
  GetUsersLoadingItemState();
}

class GetUsersSuccessState extends GetUsersState {
  final List<Users> userList;
  final String message;

  GetUsersSuccessState(
    this.userList,
    this.message,
  );
}

class GetUsersFailedState extends GetUsersState {
  final List<Users> userList;
  final String message;

  GetUsersFailedState(
    this.userList,
    this.message,
  );
}

class GetUsersExceptionState extends GetUsersState {
  final List<Users> userList;
  final String message;

  GetUsersExceptionState(
    this.userList,
    this.message,
  );
}
