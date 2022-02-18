part of 'add_wallet_offer_bloc.dart';

abstract class AddWalletOfferEvent extends Equatable {
  AddWalletOfferEvent();

  @override
  List<Object> get props => [];
}

class AddWalletOfferAddEvent extends AddWalletOfferEvent {
  final Map<String, dynamic> addWalletOfferData;

  AddWalletOfferAddEvent({
    required this.addWalletOfferData,
  });
}
