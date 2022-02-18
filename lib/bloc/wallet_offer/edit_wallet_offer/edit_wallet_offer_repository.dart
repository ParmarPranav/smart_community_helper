part of 'edit_wallet_offer_bloc.dart';

class EditWalletOfferRepository {
  WalletOffer? _walletOffer;
  String _message = '';

  String get message {
    return _message;
  }

  WalletOffer? get walletOffer {
    return _walletOffer;
  }

  Future<void> editWalletOffer({required Map<String, dynamic> data}) async {
    String url = '${ProjectConstant.hostUrl}admin/walletoffer/editwalletoffer';

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if (_message == 'Wallet Offer Updated Successfully') {
          final walletOfferJson = responseJsonMap['wallet_offer'] as dynamic;
          _walletOffer = WalletOffer.fromJson(walletOfferJson);
        }
      } else if (response.statusCode == 422) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
      } else {
        _message = "Server Connection Error !!";
      }
    } catch (error) {
      print(error);
      _message = "Server Connection Error !!";
      rethrow;
    }
  }
}
