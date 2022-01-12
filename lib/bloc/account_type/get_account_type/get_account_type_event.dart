part of 'get_account_type_bloc.dart';

abstract class GetAccountTypeEvent extends Equatable {
  GetAccountTypeEvent();

  @override
  List<Object> get props => [];
}

class GetAccountTypeDataEvent extends GetAccountTypeEvent {
  GetAccountTypeDataEvent();
}

class GetAccountTypeDeleteEvent extends GetAccountTypeEvent {
  final int accountTypeId;

  GetAccountTypeDeleteEvent({required this.accountTypeId});
}

class GetAccountTypeDeleteAllEvent extends GetAccountTypeEvent {
  final List<Map<String, dynamic>> accountTypeList;

  GetAccountTypeDeleteAllEvent({required this.accountTypeList});
}
