part of 'edit_wallet_offer_bloc.dart';

abstract class EditWalletOfferEvent extends Equatable {
  EditWalletOfferEvent();

  @override
  List<Object> get props => [];
}

class EditWalletOfferEditEvent extends EditWalletOfferEvent {
  final Map<String, dynamic> editWalletOfferData;

  EditWalletOfferEditEvent({
    required this.editWalletOfferData,
  });
}
