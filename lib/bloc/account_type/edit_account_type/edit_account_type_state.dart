part of 'edit_account_type_bloc.dart';

abstract class EditAccountTypeState extends Equatable {
  const EditAccountTypeState();

  @override
  List<Object> get props => [];
}

class EditAccountTypeInitialState extends EditAccountTypeState {}

class EditAccountTypeLoadingState extends EditAccountTypeState {
  const EditAccountTypeLoadingState();
}

class EditAccountTypeSuccessState extends EditAccountTypeState {
  final AccountType? accountType;
  final String message;

  EditAccountTypeSuccessState(
    this.accountType,
    this.message,
  );
}

class EditAccountTypeFailureState extends EditAccountTypeState {
  final String message;

  EditAccountTypeFailureState(
    this.message,
  );
}

class EditAccountTypeExceptionState extends EditAccountTypeState {
  final String message;

  EditAccountTypeExceptionState(
    this.message,
  );
}
