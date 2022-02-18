part of 'get_wallet_offer_bloc.dart';

class GetWalletOfferRepository {
  String _message = '';
  List<WalletOffer> _walletOfferList = [];

  String get message {
    return _message;
  }

  List<WalletOffer> get walletOfferList {
    return _walletOfferList;
  }

  Future<void> getWalletOfferList() async {
    String url = '${ProjectConstant.hostUrl}admin/walletoffer/getwalletoffer';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        _walletOfferList.clear();
        if (_message == 'Wallet Offer Fetched Successfully') {
          final walletOfferListJson = responseJsonMap['wallet_offer'] as List<dynamic>;
          final walletOfferListData = walletOfferListJson.map((walletOfferJson) {
            return WalletOffer.fromJson(walletOfferJson);
          }).toList();
          _walletOfferList = walletOfferListData;
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
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> updateWalletOffer(Map<String, dynamic> data) async {
    String url = '${ProjectConstant.hostUrl}admin/walletoffer/updatestatuswalletoffer';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final message = responseJsonMap['message'] as String;
        _message = message;
        if(message == 'Status Updated Successfully'){
          _walletOfferList = _walletOfferList.map((walletOffer) {
            if (walletOffer.id == data['id']) {
              return WalletOffer(
                id: walletOffer.id,
                walletAmount: walletOffer.walletAmount,
                bonusAmount: walletOffer.bonusAmount,
                status: data['status'],
                createdAt: walletOffer.createdAt,
                updatedAt: walletOffer.updatedAt,
              );
            } else {
              return WalletOffer(
                id: walletOffer.id,
                walletAmount: walletOffer.walletAmount,
                bonusAmount: walletOffer.bonusAmount,
                status: walletOffer.status,
                createdAt: walletOffer.createdAt,
                updatedAt: walletOffer.updatedAt,
              );
            }
          }).toList();
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
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteWalletOffer(Map<String, dynamic> id) async {
    String url = '${ProjectConstant.hostUrl}admin/walletoffer/deletewalletoffer';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(id), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'Wallet Offer Deleted Successfully') {
        _walletOfferList.removeWhere(
          (user) => user.id == id['id'],
        );
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }

  Future<void> deleteAllWalletOffer(List<Map<String, dynamic>> idList) async {
    String url = '${ProjectConstant.hostUrl}admin/walletoffer/deleteallwalletoffer';
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({'wallet_offer_arr': idList}), headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.body);
      final responseJsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final message = responseJsonMap['message'] as String;
      _message = message;
      if (_message == 'All Wallet Offer Deleted Successfully') {
        for (var emailData in idList) {
          _walletOfferList.removeWhere((user) => user.id == emailData['id']);
        }
      }
    } catch (error) {
      print(error);
      _message = 'Server Connection Error';
      rethrow;
    }
  }
}
