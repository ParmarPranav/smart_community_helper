import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../models/account_type.dart';
import '../../../utils/project_constant.dart';

part 'get_account_type_event.dart';

part 'get_account_type_repository.dart';

part 'get_account_type_state.dart';

class GetAccountTypeBloc extends Bloc<GetAccountTypeEvent, GetAccountTypeState> {
  GetAccountTypeRepository getAccountTypeRepository = GetAccountTypeRepository();

  GetAccountTypeBloc() : super(GetAccountTypeInitialState()) {
    on<GetAccountTypeDataEvent>(_getAccountTypeDataEvent);
    on<GetAccountTypeDeleteEvent>(_getAccountTypeDeleteEvent);
    on<GetAccountTypeDeleteAllEvent>(_getAccountTypeDeleteAllEvent);
  }

  void _getAccountTypeDataEvent(GetAccountTypeDataEvent event, Emitter<GetAccountTypeState> emit) async {
    emit(GetAccountTypeLoadingState());
    try {
      await getAccountTypeRepository.getAccountTypeList();
      if (getAccountTypeRepository.message == 'Account Types Fetched Successfully') {
        emit(GetAccountTypeSuccessState(
          getAccountTypeRepository.accountTypeList,
          getAccountTypeRepository.message,
        ));
      } else {
        emit(GetAccountTypeFailedState(
          getAccountTypeRepository.accountTypeList,
          getAccountTypeRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetAccountTypeExceptionState(
        getAccountTypeRepository.accountTypeList,
        getAccountTypeRepository.message,
      ));
    }
  }

  void _getAccountTypeDeleteEvent(GetAccountTypeDeleteEvent event, Emitter<GetAccountTypeState> emit) async {
    emit(GetAccountTypeLoadingState());
    try {
      await getAccountTypeRepository.deleteAccountType(event.accountTypeId);
      if (getAccountTypeRepository.message == 'Account Type Deleted Successfully') {
        emit(GetAccountTypeSuccessState(
          getAccountTypeRepository.accountTypeList,
          getAccountTypeRepository.message,
        ));
      } else {
        emit(GetAccountTypeFailedState(
          getAccountTypeRepository.accountTypeList,
          getAccountTypeRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetAccountTypeExceptionState(
        getAccountTypeRepository.accountTypeList,
        getAccountTypeRepository.message,
      ));
    }
  }

  void _getAccountTypeDeleteAllEvent(GetAccountTypeDeleteAllEvent event, Emitter<GetAccountTypeState> emit) async {
    emit(GetAccountTypeLoadingState());
    try {
      await getAccountTypeRepository.deleteAllAccountType(event.accountTypeList);
      if (getAccountTypeRepository.message == 'Account Types Deleted Successfully') {
        emit(GetAccountTypeSuccessState(
          getAccountTypeRepository.accountTypeList,
          getAccountTypeRepository.message,
        ));
      } else {
        emit(GetAccountTypeFailedState(
          getAccountTypeRepository.accountTypeList,
          getAccountTypeRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetAccountTypeExceptionState(
        getAccountTypeRepository.accountTypeList,
        getAccountTypeRepository.message,
      ));
    }
  }
}
