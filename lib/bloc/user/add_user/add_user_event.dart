part of 'add_user_bloc.dart';

abstract class AddUserEvent extends Equatable {
  AddUserEvent();

  @override
  List<Object> get props => [];
}

class AddUserAddEvent extends AddUserEvent {
  final Map<String, dynamic> addUserData;

  AddUserAddEvent({
    required this.addUserData,
  });
}
