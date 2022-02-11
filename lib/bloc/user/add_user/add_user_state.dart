part of 'add_user_bloc.dart';

abstract class AddUserState extends Equatable {
  const AddUserState();

  @override
  List<Object> get props => [];
}

class AddUserInitialState extends AddUserState {}

class AddUserLoadingState extends AddUserState {
  AddUserLoadingState();
}

class AddUserSuccessState extends AddUserState {
  final Users? users;
  final String message;

  AddUserSuccessState(
    this.users,
    this.message,
  );
}

class AddUserFailureState extends AddUserState {
  final String message;

  AddUserFailureState(
    this.message,
  );
}

class AddUserExceptionState extends AddUserState {
  final String message;

  AddUserExceptionState(
    this.message,
  );
}
