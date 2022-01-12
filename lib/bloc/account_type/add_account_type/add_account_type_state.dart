part of 'add_account_type_bloc.dart';

abstract class AddAccountTypeState extends Equatable {
  const AddAccountTypeState();

  @override
  List<Object> get props => [];
}

class AddAccountTypeInitialState extends AddAccountTypeState {}

class AddAccountTypeLoadingState extends AddAccountTypeState {
  const AddAccountTypeLoadingState();
}

class AddAccountTypeSuccessState extends AddAccountTypeState {
  final AccountType? accountType;
  final String message;

  const AddAccountTypeSuccessState(
    this.accountType,
    this.message,
  );
}

class AddAccountTypeFailureState extends AddAccountTypeState {
  final String message;

  const AddAccountTypeFailureState(
    this.message,
  );
}

class AddAccountTypeExceptionState extends AddAccountTypeState {
  final String message;

  const AddAccountTypeExceptionState(
    this.message,
  );
}
