import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../models/wallet_offer.dart';

part 'add_wallet_offer_event.dart';

part 'add_wallet_offer_repository.dart';

part 'add_wallet_offer_state.dart';

class AddWalletOfferBloc extends Bloc<AddWalletOfferEvent, AddWalletOfferState> {
  AddWalletOfferRepository addWalletOfferRepository = AddWalletOfferRepository();

  AddWalletOfferBloc() : super(AddWalletOfferInitialState()) {
    on<AddWalletOfferAddEvent>(_addWalletOfferAddEvent);
  }

  void _addWalletOfferAddEvent(AddWalletOfferAddEvent event, Emitter<AddWalletOfferState> emit) async {
    emit(AddWalletOfferLoadingState());
    try {
      await addWalletOfferRepository.addWalletOffer(
        data: event.addWalletOfferData,
      );
      if (addWalletOfferRepository.message == 'Wallet Offers Added Successfully') {
        emit(AddWalletOfferSuccessState(
          addWalletOfferRepository.walletOffer,
          addWalletOfferRepository.message,
        ));
      } else {
        emit(AddWalletOfferFailureState(
          addWalletOfferRepository.message,
        ));
      }
    } catch (error) {
      print(error);
      emit(AddWalletOfferExceptionState(
        addWalletOfferRepository.message,
      ));
    }
  }
}
