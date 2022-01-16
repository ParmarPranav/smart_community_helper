part of 'add_account_type_bloc.dart';

abstract class AddAccountTypeState extends Equatable {
  AddAccountTypeState();

  @override
  List<Object> get props => [];
}

class AddAccountTypeInitialState extends AddAccountTypeState {}

class AddAccountTypeLoadingState extends AddAccountTypeState {
  AddAccountTypeLoadingState();
}

class AddAccountTypeSuccessState extends AddAccountTypeState {
  final AccountType? accountType;
  final String message;

  AddAccountTypeSuccessState(
    this.accountType,
    this.message,
  );
}

class AddAccountTypeFailureState extends AddAccountTypeState {
  final String message;

  AddAccountTypeFailureState(
    this.message,
  );
}

class AddAccountTypeExceptionState extends AddAccountTypeState {
  final String message;

  AddAccountTypeExceptionState(
    this.message,
  );
}
