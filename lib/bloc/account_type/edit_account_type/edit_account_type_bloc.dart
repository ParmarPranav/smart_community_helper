import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/account_type.dart';

import '../../../repository/account_type/edit_account_type_repository.dart';

part 'edit_account_type_event.dart';

part 'edit_account_type_state.dart';

class EditAccountTypeBloc extends Bloc<EditAccountTypeEvent, EditAccountTypeState> {
  EditAccountTypeRepository editAccountTypeRepository = EditAccountTypeRepository();

  EditAccountTypeBloc() : super(EditAccountTypeInitialState()) {
    on<EditAccountTypeEditEvent>(_editAccountTypeEditEvent);
  }

  void _editAccountTypeEditEvent(EditAccountTypeEditEvent event, Emitter<EditAccountTypeState> emit) async {
    emit(EditAccountTypeLoadingState());
    try {
      await editAccountTypeRepository.editAccountType(
        editAccountTypeData: event.editAccountData,
      );
      if (editAccountTypeRepository.message == 'Account Type Updated Successfully') {
        emit(EditAccountTypeSuccessState(
          editAccountTypeRepository.accountType,
          editAccountTypeRepository.message,
        ));
      } else {
        emit(EditAccountTypeFailureState(
          editAccountTypeRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditAccountTypeExceptionState(
        editAccountTypeRepository.message,
      ));
    }
  }
}
