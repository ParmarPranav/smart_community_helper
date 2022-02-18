import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;

import '../../../models/wallet_offer.dart';

part 'edit_wallet_offer_event.dart';
part 'edit_wallet_offer_repository.dart';
part 'edit_wallet_offer_state.dart';

class EditWalletOfferBloc extends Bloc<EditWalletOfferEvent, EditWalletOfferState> {
  EditWalletOfferRepository editWalletOfferRepository = EditWalletOfferRepository();

  EditWalletOfferBloc() : super(EditWalletOfferInitialState()) {
    on<EditWalletOfferEditEvent>(_editWalletOfferEditEvent);
  }

  void _editWalletOfferEditEvent(EditWalletOfferEditEvent event, Emitter<EditWalletOfferState> emit) async {
    emit(EditWalletOfferLoadingState());
    try {
      await editWalletOfferRepository.editWalletOffer(
        data: event.editWalletOfferData,
      );
      if (editWalletOfferRepository.message == 'Wallet Offer Updated Successfully') {
        emit(EditWalletOfferSuccessState(
          editWalletOfferRepository.walletOffer,
          editWalletOfferRepository.message,
        ));
      } else {
        emit(EditWalletOfferFailureState(
          editWalletOfferRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(EditWalletOfferExceptionState(
        editWalletOfferRepository.message,
      ));
    }
  }
}
