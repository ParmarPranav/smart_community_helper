part of 'edit_account_type_bloc.dart';

abstract class EditAccountTypeEvent extends Equatable {
  const EditAccountTypeEvent();

  @override
  List<Object> get props => [];
}

class EditAccountTypeEditEvent extends EditAccountTypeEvent {
  final Map<String, dynamic> editAccountData;

  EditAccountTypeEditEvent({required this.editAccountData});
}
