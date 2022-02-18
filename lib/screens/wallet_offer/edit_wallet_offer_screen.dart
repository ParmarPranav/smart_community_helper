import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';

import '../../bloc/wallet_offer/edit_wallet_offer/edit_wallet_offer_bloc.dart';
import '../../models/wallet_offer.dart';
import '../responsive_layout.dart';

class EditWalletOfferScreen extends StatefulWidget {
  const EditWalletOfferScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-wallet-offer";

  @override
  _EditWalletOfferScreenState createState() => _EditWalletOfferScreenState();
}

class _EditWalletOfferScreenState extends State<EditWalletOfferScreen> {
  bool _isInit = true;
  WalletOffer? walletOffer;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _walletAmountController = TextEditingController();
  var _bonusAmountController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  Map<String, dynamic> _data = {
    'id': 0,
    'wallet_amount': 0.0,
    'bonus_amount': 0.0,
  };

  final EditWalletOfferBloc _editWalletOfferBloc = EditWalletOfferBloc();

  bool validate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      walletOffer = ModalRoute.of(context)!.settings.arguments as WalletOffer;
      _data['id'] = walletOffer!.id;
      _bonusAmountController.text = walletOffer!.bonusAmount.toString();
      _walletAmountController.text = walletOffer!.walletAmount.toString();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        smallScreen: _buildMobileTabletView(),
        mediumScreen: _buildMobileTabletView(),
        largeScreen: _buildWebView(),
      ),
    );
  }

  Widget _buildMobileTabletView() {
    return Container();
  }

  Widget _buildWebView() {
    return BlocConsumer<EditWalletOfferBloc, EditWalletOfferState>(
      bloc: _editWalletOfferBloc,
      listener: (context, state) {
        if (state is EditWalletOfferSuccessState) {
          Navigator.of(context).pop(state.message);
        } else if (state is EditWalletOfferFailureState) {
          _showSnackMessage(state.message, Colors.red);
        } else if (state is EditWalletOfferExceptionState) {
          _showSnackMessage(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: BackButtonNew(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 35,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Edit Wallet Offer',
                      style: ProjectConstant.WorkSansFontBoldTextStyle(
                        fontSize: 20,
                        fontColor: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    _bonusAmountInputWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    _walletAmountInputWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 500,
                      height: 55,
                      margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            validate = true;
                          });
                          if (!isFormValid()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          _editWalletOfferBloc.add(EditWalletOfferEditEvent(editWalletOfferData: _data));
                        },
                        child: Text(
                          'SAVE',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(containerRadius),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Column _bonusAmountInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _bonusAmountController.text == '' && validate ? Colors.red : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(containerRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(containerRadius),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: TextFormField(
              controller: _bonusAmountController,
              decoration: InputDecoration(
                hintText: 'Bonus Amount',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
              onSaved: (newValue) {
                _data['bonus_amount'] = newValue != '' ? num.parse(newValue!.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_bonusAmountController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  'Required Field !!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  Column _walletAmountInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _walletAmountController.text == '' && validate ? Colors.red : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(containerRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(containerRadius),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: TextFormField(
              controller: _walletAmountController,
              decoration: InputDecoration(
                hintText: 'Wallet Amount',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
              onSaved: (newValue) {
                _data['wallet_amount'] = newValue != '' ? num.parse(newValue!.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_walletAmountController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  'Required Field !!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  void _showSnackMessage(String message, Color color, [int seconds = 3]) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: seconds),
      ),
    );
  }

  bool isFormValid() {
    return _bonusAmountController.text != '' && _walletAmountController.text != '' ;
  }
}
