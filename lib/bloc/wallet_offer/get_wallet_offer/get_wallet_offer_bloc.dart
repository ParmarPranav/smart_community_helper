import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/wallet_offer.dart';

part 'get_wallet_offer_event.dart';

part 'get_wallet_offer_repository.dart';

part 'get_wallet_offer_state.dart';

class GetWalletOfferBloc extends Bloc<GetWalletOfferEvent, GetWalletOfferState> {
  GetWalletOfferRepository getWalletOfferRepository = GetWalletOfferRepository();

  GetWalletOfferBloc() : super(GetWalletOfferInitialState()) {
    on<GetWalletOfferDataEvent>(_getWalletOfferDataEvent);
    on<UpdateWalletOfferEvent>(_updateWalletOfferDataEvent);
    on<GetWalletOfferDeleteEvent>(_getWalletOfferDeleteEvent);
    on<GetWalletOfferDeleteAllEvent>(_getWalletOfferDeleteAllEvent);
  }

  void _getWalletOfferDataEvent(GetWalletOfferDataEvent event, Emitter<GetWalletOfferState> emit) async {
    emit(GetWalletOfferLoadingState());
    try {
      await getWalletOfferRepository.getWalletOfferList();
      if (getWalletOfferRepository.message == 'Wallet Offer Fetched Successfully') {
        emit(GetWalletOfferSuccessState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      } else {
        emit(GetWalletOfferFailedState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetWalletOfferExceptionState(
        getWalletOfferRepository.walletOfferList,
        getWalletOfferRepository.message,
      ));
    }
  }

  void _updateWalletOfferDataEvent(UpdateWalletOfferEvent event, Emitter<GetWalletOfferState> emit) async {
    emit(GetWalletOfferLoadingState());
    try {
      await getWalletOfferRepository.updateWalletOffer(event.data);
      if (getWalletOfferRepository.message == 'Status Updated Successfully') {
        emit(GetWalletOfferSuccessState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      } else {
        emit(GetWalletOfferFailedState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetWalletOfferExceptionState(
        getWalletOfferRepository.walletOfferList,
        getWalletOfferRepository.message,
      ));
    }
  }

  void _getWalletOfferDeleteEvent(GetWalletOfferDeleteEvent event, Emitter<GetWalletOfferState> emit) async {
    emit(GetWalletOfferLoadingItemState());
    try {
      await getWalletOfferRepository.deleteWalletOffer(event.walletOffer);
      if (getWalletOfferRepository.message == 'Wallet Offer Deleted Successfully') {
        emit(GetWalletOfferSuccessState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      } else {
        emit(GetWalletOfferFailedState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetWalletOfferExceptionState(
        getWalletOfferRepository.walletOfferList,
        getWalletOfferRepository.message,
      ));
    }
  }

  void _getWalletOfferDeleteAllEvent(GetWalletOfferDeleteAllEvent event, Emitter<GetWalletOfferState> emit) async {
    emit(GetWalletOfferLoadingItemState());
    try {
      await getWalletOfferRepository.deleteAllWalletOffer(event.walletOfferList);
      if (getWalletOfferRepository.message == 'All Wallet Offer Deleted Successfully') {
        emit(GetWalletOfferSuccessState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      } else {
        emit(GetWalletOfferFailedState(
          getWalletOfferRepository.walletOfferList,
          getWalletOfferRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(GetWalletOfferExceptionState(
        getWalletOfferRepository.walletOfferList,
        getWalletOfferRepository.message,
      ));
    }
  }
}
