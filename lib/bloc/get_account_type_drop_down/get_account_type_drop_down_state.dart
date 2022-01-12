part of 'get_account_type_drop_down_bloc.dart';

abstract class GetAccountTypeDropDownState extends Equatable {
  GetAccountTypeDropDownState();

  @override
  List<Object> get props => [];
}

class GetAccountTypeDropDownInitialState extends GetAccountTypeDropDownState {}

class GetAccountTypeDropDownLoadingState extends GetAccountTypeDropDownState {
  GetAccountTypeDropDownLoadingState();
}

class GetAccountTypeDropDownSuccessState extends GetAccountTypeDropDownState {
  final List<AccountTypeDropDown> accountTypeList;
  final String message;

  GetAccountTypeDropDownSuccessState(
    this.accountTypeList,
    this.message,
  );
}

class GetAccountTypeDropDownFailedState extends GetAccountTypeDropDownState {
  final List<AccountTypeDropDown> accountTypeList;
  final String message;

  GetAccountTypeDropDownFailedState(
    this.accountTypeList,
    this.message,
  );
}

class GetAccountTypeDropDownExceptionState extends GetAccountTypeDropDownState {
  final List<AccountTypeDropDown> accountTypeList;
  final String message;

  GetAccountTypeDropDownExceptionState(
    this.accountTypeList,
    this.message,
  );
}
