part of 'edit_user_bloc.dart';

abstract class EditUserEvent extends Equatable {
  EditUserEvent();

  @override
  List<Object> get props => [];
}

class EditUserEditEvent extends EditUserEvent {
  final Map<String, dynamic> editUserData;

  EditUserEditEvent({
    required this.editUserData,
  });
}
