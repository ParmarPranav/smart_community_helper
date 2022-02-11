part of 'edit_user_bloc.dart';

abstract class EditUserState extends Equatable {
  const EditUserState();

  @override
  List<Object> get props => [];
}

class EditUserInitialState extends EditUserState {}

class EditUserLoadingState extends EditUserState {
  EditUserLoadingState();
}

class EditUserSuccessState extends EditUserState {
  final Users? deliveryCharges;
  final String message;

  EditUserSuccessState(
    this.deliveryCharges,
    this.message,
  );
}

class EditUserFailureState extends EditUserState {
  final String message;

  EditUserFailureState(
    this.message,
  );
}

class EditUserExceptionState extends EditUserState {
  final String message;

  EditUserExceptionState(
    this.message,
  );
}
