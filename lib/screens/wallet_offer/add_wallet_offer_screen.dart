import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';

import '../../bloc/wallet_offer/add_wallet_offer/add_wallet_offer_bloc.dart';
import '../responsive_layout.dart';

class AddWalletOfferScreen extends StatefulWidget {
  static const routeName = '/add-wallet-offer';

  AddWalletOfferScreen({Key? key}) : super(key: key);

  @override
  _AddWalletOfferScreenState createState() => _AddWalletOfferScreenState();
}

class _AddWalletOfferScreenState extends State<AddWalletOfferScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _walletAmountController = TextEditingController();
  var _bonusController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  Map<String, dynamic> _data = {
    'wallet_amount': 0.0,
    'bonus_amount': 0.0,
  };

  final AddWalletOfferBloc _addWalletOfferBloc = AddWalletOfferBloc();

  bool validate = false;

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
    return BlocConsumer<AddWalletOfferBloc, AddWalletOfferState>(
      bloc: _addWalletOfferBloc,
      listener: (context, state) {
        if (state is AddWalletOfferSuccessState) {
          Navigator.of(context).pop(state.message);
        } else if (state is AddWalletOfferFailureState) {
          _showSnackMessage(state.message, Colors.red);
        } else if (state is AddWalletOfferExceptionState) {
          _showSnackMessage(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
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
                    'Add Wallet Offer',
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
              Form(
                key: _formKey,
                child: Column(
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
                          if (num.parse(_bonusController.text).toDouble() > num.parse(_walletAmountController.text).toDouble()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          _addWalletOfferBloc.add(AddWalletOfferAddEvent(addWalletOfferData: _data));
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
              ),
            ],
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
            color: _bonusController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _bonusController,
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
        if (_bonusController.text == '' && validate)
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
    return _bonusController.text != '' && _walletAmountController.text != '' ;
  }
}
