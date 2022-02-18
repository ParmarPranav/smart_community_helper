part of 'edit_wallet_offer_bloc.dart';

abstract class EditWalletOfferState extends Equatable {
  const EditWalletOfferState();

  @override
  List<Object> get props => [];
}

class EditWalletOfferInitialState extends EditWalletOfferState {}

class EditWalletOfferLoadingState extends EditWalletOfferState {
  EditWalletOfferLoadingState();
}

class EditWalletOfferSuccessState extends EditWalletOfferState {
  final WalletOffer? walletOffer;
  final String message;

  EditWalletOfferSuccessState(
    this.walletOffer,
    this.message,
  );
}

class EditWalletOfferFailureState extends EditWalletOfferState {
  final String message;

  EditWalletOfferFailureState(
    this.message,
  );
}

class EditWalletOfferExceptionState extends EditWalletOfferState {
  final String message;

  EditWalletOfferExceptionState(
    this.message,
  );
}
