import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/repository/get_account_type_drop_down_repository.dart';

import '../../models/account_type_drop_down.dart';

part 'get_account_type_drop_down_event.dart';

part 'get_account_type_drop_down_state.dart';

class GetAccountTypeDropDownBloc extends Bloc<GetAccountTypeDropDownEvent, GetAccountTypeDropDownState> {
  GetAccountTypeDropDownRepository getAccountTypeDropDownRepository = GetAccountTypeDropDownRepository();

  GetAccountTypeDropDownBloc() : super(GetAccountTypeDropDownInitialState()) {
    on<GetAccountTypeDropDownDataEvent>(_getAccountTypeDropDownDataEvent);
  }

  void _getAccountTypeDropDownDataEvent(GetAccountTypeDropDownEvent event, Emitter<GetAccountTypeDropDownState> emit) async {
    emit(GetAccountTypeDropDownLoadingState());
    try {
      await getAccountTypeDropDownRepository.getAccountTypeDropDownList();
      if (getAccountTypeDropDownRepository.message == 'Account Types Fetched Successfully') {
        emit(GetAccountTypeDropDownSuccessState(
          getAccountTypeDropDownRepository.accountTypeList,
          getAccountTypeDropDownRepository.message,
        ));
      } else {
        emit(GetAccountTypeDropDownFailedState(
          getAccountTypeDropDownRepository.accountTypeList,
          getAccountTypeDropDownRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetAccountTypeDropDownExceptionState(
        getAccountTypeDropDownRepository.accountTypeList,
        getAccountTypeDropDownRepository.message,
      ));
    }
  }
}
