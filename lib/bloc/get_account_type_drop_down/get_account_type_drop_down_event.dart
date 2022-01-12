part of 'get_account_type_drop_down_bloc.dart';

abstract class GetAccountTypeDropDownEvent extends Equatable {
  const GetAccountTypeDropDownEvent();

  @override
  List<Object> get props => [];
}

class GetAccountTypeDropDownDataEvent extends GetAccountTypeDropDownEvent {
  const GetAccountTypeDropDownDataEvent();
}
