part of 'get_wallet_offer_bloc.dart';

abstract class GetWalletOfferEvent extends Equatable {
  const GetWalletOfferEvent();

  @override
  List<Object> get props => [];
}

class GetWalletOfferDataEvent extends GetWalletOfferEvent {
  GetWalletOfferDataEvent();
}

class GetWalletOfferDeleteEvent extends GetWalletOfferEvent {
  final Map<String, dynamic> walletOffer;

  GetWalletOfferDeleteEvent({
    required this.walletOffer,
  });
}

class UpdateWalletOfferEvent extends GetWalletOfferEvent {
  final Map<String, dynamic> data;

  UpdateWalletOfferEvent({
    required this.data,
  });
}

class GetWalletOfferDeleteAllEvent extends GetWalletOfferEvent {
  final List<Map<String, dynamic>> walletOfferList;

  GetWalletOfferDeleteAllEvent({
    required this.walletOfferList,
  });
}
