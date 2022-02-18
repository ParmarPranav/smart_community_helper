part of 'add_wallet_offer_bloc.dart';

abstract class AddWalletOfferState extends Equatable {
  const AddWalletOfferState();

  @override
  List<Object> get props => [];
}

class AddWalletOfferInitialState extends AddWalletOfferState {}

class AddWalletOfferLoadingState extends AddWalletOfferState {
  AddWalletOfferLoadingState();
}

class AddWalletOfferSuccessState extends AddWalletOfferState {
  final WalletOffer? walletOffer;
  final String message;

  AddWalletOfferSuccessState(
    this.walletOffer,
    this.message,
  );
}

class AddWalletOfferFailureState extends AddWalletOfferState {
  final String message;

  AddWalletOfferFailureState(
    this.message,
  );
}

class AddWalletOfferExceptionState extends AddWalletOfferState {
  final String message;

  AddWalletOfferExceptionState(
    this.message,
  );
}
