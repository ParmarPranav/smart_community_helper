import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/account_type.dart';
import '../../../repository/account_type/add_account_type_repository.dart';

part 'add_account_type_event.dart';

part 'add_account_type_state.dart';

class AddAccountTypeBloc extends Bloc<AddAccountTypeEvent, AddAccountTypeState> {
  AddAccountTypeRepository addAccountTypeRepository = AddAccountTypeRepository();

  AddAccountTypeBloc() : super(AddAccountTypeInitialState()) {
    on<AddAccountTypeAddEvent>(_addAccountTypeAddEvent);
  }

  void _addAccountTypeAddEvent(AddAccountTypeAddEvent event, Emitter<AddAccountTypeState> emit) async {
    emit(AddAccountTypeLoadingState());
    try {
      await addAccountTypeRepository.addAccountType(accountTypeData: event.addAccountTypeData);
      if (addAccountTypeRepository.message == 'Account Type Added Successfully') {
        emit(AddAccountTypeSuccessState(
          addAccountTypeRepository.accountType,
          addAccountTypeRepository.message,
        ));
      } else {
        emit(AddAccountTypeFailureState(
          addAccountTypeRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddAccountTypeExceptionState(
        addAccountTypeRepository.message,
      ));
    }
  }
}
