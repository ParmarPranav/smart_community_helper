part of 'get_wallet_offer_bloc.dart';

abstract class GetWalletOfferState extends Equatable {
  const GetWalletOfferState();

  @override
  List<Object> get props => [];
}

class GetWalletOfferInitialState extends GetWalletOfferState {}

class GetWalletOfferLoadingState extends GetWalletOfferState {
  GetWalletOfferLoadingState();
}

class GetWalletOfferLoadingItemState extends GetWalletOfferState {
  GetWalletOfferLoadingItemState();
}

class GetWalletOfferSuccessState extends GetWalletOfferState {
  final List<WalletOffer> walletOfferList;
  final String message;

  GetWalletOfferSuccessState(
    this.walletOfferList,
    this.message,
  );
}

class GetWalletOfferFailedState extends GetWalletOfferState {
  final List<WalletOffer> walletOfferList;
  final String message;

  GetWalletOfferFailedState(
    this.walletOfferList,
    this.message,
  );
}

class GetWalletOfferExceptionState extends GetWalletOfferState {
  final List<WalletOffer> walletOfferList;
  final String message;

  GetWalletOfferExceptionState(
    this.walletOfferList,
    this.message,
  );
}
