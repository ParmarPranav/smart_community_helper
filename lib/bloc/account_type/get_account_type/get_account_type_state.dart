part of 'get_account_type_bloc.dart';

abstract class GetAccountTypeState extends Equatable {
  const GetAccountTypeState();

  @override
  List<Object> get props => [];
}

class GetAccountTypeInitialState extends GetAccountTypeState {}

class GetAccountTypeLoadingState extends GetAccountTypeState {
  GetAccountTypeLoadingState();
}

class GetAccountTypeLoadingItemState extends GetAccountTypeState {
  final List<AccountType> accountTypeList;

  GetAccountTypeLoadingItemState(this.accountTypeList);
}

class GetAccountTypeSuccessState extends GetAccountTypeState {
  final List<AccountType> accountTypeList;
  final String message;

  GetAccountTypeSuccessState(
    this.accountTypeList,
    this.message,
  );
}

class GetAccountTypeFailedState extends GetAccountTypeState {
  final List<AccountType> accountTypeList;
  final String message;

  GetAccountTypeFailedState(
    this.accountTypeList,
    this.message,
  );
}

class GetAccountTypeExceptionState extends GetAccountTypeState {
  final List<AccountType> accountTypeList;
  final String message;

  const GetAccountTypeExceptionState(
    this.accountTypeList,
    this.message,
  );
}
