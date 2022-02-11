import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/delivery_charges/edit_delivery_charges/edit_delivery_charges_bloc.dart';
import 'package:food_hunt_admin_app/bloc/register_city/get_register_city/get_register_city_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/models/register_city.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';

import '../responsive_layout.dart';

class EditDeliveryChargesScreen extends StatefulWidget {
  const EditDeliveryChargesScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-delivery-charges";

  @override
  _EditDeliveryChargesScreenState createState() => _EditDeliveryChargesScreenState();
}

class _EditDeliveryChargesScreenState extends State<EditDeliveryChargesScreen> {
  bool _isInit = true;
  DeliveryCharges? deliveryCharges;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<RegisterCity> _registerCity = [];

  var _toController = TextEditingController();
  var _fromController = TextEditingController();
  var _chargesController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  Map<String, dynamic> _data = {
    'id': 0,
    'from': 0.0,
    'to': 0.0,
    'charges': 0.0,
    'register_city_id': 0,
  };

  final GetRegisterCityBloc _getRegisterCityBloc = GetRegisterCityBloc();
  final EditDeliveryChargesBloc _editDeliveryChargesBloc = EditDeliveryChargesBloc();

  bool validate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getRegisterCityBloc.add(GetRegisterCityDataEvent());
      deliveryCharges = ModalRoute.of(context)!.settings.arguments as DeliveryCharges;
      _data['id'] = deliveryCharges!.id;
      _data['register_city_id'] = deliveryCharges!.registerCityId;
      _fromController.text = deliveryCharges!.from.toString();
      _toController.text = deliveryCharges!.to.toString();
      _chargesController.text = deliveryCharges!.charge.toString();
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
    return BlocConsumer<EditDeliveryChargesBloc, EditDeliveryChargesState>(
      bloc: _editDeliveryChargesBloc,
      listener: (context, state) {
        if (state is EditDeliveryChargesSuccessState) {
          Navigator.of(context).pop(state.message);
        } else if (state is EditDeliveryChargesFailureState) {
          _showSnackMessage(state.message, Colors.red);
        } else if (state is EditDeliveryChargesExceptionState) {
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
                      'Edit Delivery Charges',
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
                    _registerCityDropDownWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _fromInputWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    _toInputWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    _chargesInputWidget(),
                    SizedBox(
                      height: 30,
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
                          _editDeliveryChargesBloc.add(EditDeliveryChargesEditEvent(editDeliveryChargesData: _data));
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

  Widget _registerCityDropDownWidget() {
    return BlocConsumer<GetRegisterCityBloc, GetRegisterCityState>(
      bloc: _getRegisterCityBloc,
      listener: (context, state) {
        if (state is GetRegisterCitySuccessState) {
          _registerCity = state.registerCityList;
        } else if (state is GetRegisterCityFailedState) {
          _showSnackMessage(state.message, Colors.red.shade600);
        } else if (state is GetRegisterCityExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade600);
        }
      },
      builder: (context, state) {
        return state is GetRegisterCityLoadingState || state is GetRegisterCityInitialState
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      color: _data['register_city_id'] == 0 && validate ? Colors.red : Colors.grey.shade800,
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
                      child: DropdownButtonFormField<RegisterCity>(
                        value: _registerCity.firstWhere((element) => element.id == deliveryCharges!.registerCityId),
                        decoration: InputDecoration(
                          hintText: 'Register City',
                          prefixIcon: Icon(Icons.restaurant_menu),
                          border: InputBorder.none,
                        ),
                        items: _registerCity.map((registerCity) {
                          return DropdownMenuItem<RegisterCity>(
                            value: registerCity,
                            child: Text(
                              registerCity.city,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        onSaved: (newValue) {
                          _data['register_city_id'] = newValue!.id;
                        },
                        onChanged: (value) {
                          _data['register_city_id'] = value!.id;
                        },
                      ),
                    ),
                  ),
                  if (_data['register_city_id'] == 0 && validate)
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
      },
    );
  }

  Column _chargesInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _chargesController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _chargesController,
              decoration: InputDecoration(
                hintText: 'Charges',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              textInputAction: TextInputAction.newline,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
              onSaved: (newValue) {
                _data['charges'] = newValue != '' ? num.parse(newValue!.trim()).toDouble() : 0.0;
              },
            ),
          ),
        ),
        if (_chargesController.text == '' && validate)
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

  Column _fromInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _fromController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _fromController,
              decoration: InputDecoration(
                hintText: 'From',
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
                _data['from'] = newValue != '' ? num.parse(newValue!.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_fromController.text == '' && validate)
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

  Column _toInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _toController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _toController,
              decoration: InputDecoration(
                hintText: 'To',
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
                _data['to'] = newValue != '' ? num.parse(newValue!.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_toController.text == '' && validate)
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
    return _fromController.text != '' && _toController.text != '' && _chargesController.text != '';
  }
}
