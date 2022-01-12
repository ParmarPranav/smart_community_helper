part of 'add_account_type_bloc.dart';

abstract class AddAccountTypeEvent extends Equatable {
  const AddAccountTypeEvent();

  @override
  List<Object> get props => [];
}

class AddAccountTypeAddEvent extends AddAccountTypeEvent {
  final Map<String, dynamic> addAccountTypeData;

  AddAccountTypeAddEvent({required this.addAccountTypeData});
}
