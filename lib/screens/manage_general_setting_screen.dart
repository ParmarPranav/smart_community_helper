import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/general_setting.dart';
import 'package:food_hunt_admin_app/screens/responsive_layout.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

import '../bloc/general_setting/get_general_setting/get_general_setting_bloc.dart';

class GeneralSettingScreen extends StatefulWidget {
  static const routeName = '/general-setting';

  @override
  _GeneralSettingScreenState createState() => _GeneralSettingScreenState();
}

class _GeneralSettingScreenState extends State<GeneralSettingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GetGeneralSettingBloc _generalSettingBloc = GetGeneralSettingBloc();
  bool validate = false;
  bool _isInit = true;

  final Map<String, dynamic> _data = {
    'id': 0,
    'is_delivery_free': '',
    'food_service_charge_percent': '',
    'liquor_service_charge_percent': '',
    'airport_delivery_charge': '',
    'railway_delivery_charge': '',
    'minimum_order_price': '',
    'taxes': '',
    'surcharge': '',
  };

  var _foodServiceChargePercentage = TextEditingController();
  var _liquorServiceChargePercentage = TextEditingController();
  var _airportDeliveryCharge = TextEditingController();
  var _railwayDeliveryCharge = TextEditingController();
  var _minimumOrderPrice= TextEditingController();
  var _taxesPrice= TextEditingController();
  var _surChargePrice= TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  GeneralSetting? generalSetting;

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      validate = true;
    });
    if (!isFormValid()) {
      return;
    }
    _data['id'] = generalSetting!.id;

    _formKey.currentState!.save();
    _generalSettingBloc.add(EditGeneralSettingEvent(
      data: _data,
    ));
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _generalSettingBloc.add(GetGeneralSettingDataEvent());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<GetGeneralSettingBloc, GetGeneralSettingState>(
          bloc: _generalSettingBloc,
          listener: (context, state) {
            if (state is GetGeneralSettingSuccessState) {
              setState(() {
                generalSetting = state.generalSetting;
                _data['is_delivery_free'] = generalSetting!.isDeliveryFree;
                _foodServiceChargePercentage.text = generalSetting!.foodServiceChargePercent.toString();
                _liquorServiceChargePercentage.text = generalSetting!.liquorServiceChargePercent.toString();
                _railwayDeliveryCharge.text = generalSetting!.railwayDeliveryCharge.toString();
                _airportDeliveryCharge.text = generalSetting!.airportDeliveryCharge.toString();
                _minimumOrderPrice.text = generalSetting!.minimumOrderPrice.toString();
                _taxesPrice.text = generalSetting!.taxes.toString();
                _surChargePrice.text = generalSetting!.surCharge.toString();
              });
              _showSnackMessage(state.message,Colors.green);

            } else if (state is GetGeneralSettingFailedState) {
              _showSnackMessage(state.message,Colors.red);
            } else if (state is GetGeneralSettingExceptionState) {
              _showSnackMessage(state.message,Colors.red);
            }
          },
          builder: (context, state) {
            return state is GetGeneralSettingLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ResponsiveLayout(
                    smallScreen: _buildMobileTabletView(context, mediaQuery, screenHeight),
                    mediumScreen: _buildMobileTabletView(context, mediaQuery, screenHeight),
                    largeScreen: _buildWebView(context, mediaQuery, screenHeight, screenWidth),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildMobileTabletView(BuildContext context, MediaQueryData mediaQuery, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'General Setting',
                    style: ProjectConstant.WorkSansFontBoldTextStyle(
                      fontSize: 20,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
              ),
              _buildGeneralSettingWidget(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 55,
                width: 200,
                child: _submitButton(),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebView(BuildContext context, MediaQueryData mediaQuery, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'General Setting',
                    style: ProjectConstant.WorkSansFontBoldTextStyle(
                      fontSize: 20,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
              ),
              _buildGeneralSettingWidget(),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                width: 200,
                child: _submitButton(),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
      ),
      child: Text(
        'Submit',
        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
          fontSize: 18,
          fontColor: Colors.white,
        ),
      ),
      onPressed: _submit,
    );
  }

  Widget _buildGeneralSettingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Row(
            children: [
              Text(
                'Delivery Free',
                style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
              ),
              SizedBox(
                width: 10,
              ),
              Switch(
                onChanged: (value) {
                  setState(() {
                    _data['is_delivery_free'] = value ? '1' : '0';
                  });
                },
                value: _data['is_delivery_free'] == '1',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Food Service Percentage',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _foodServiceChargePercentage.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _foodServiceChargePercentage,
              decoration: InputDecoration(
                  hintText: 'Food Service Charge Percentage',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.design_services,
                  ),
                  suffix: Text(
                    '% ',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['food_service_charge_percent'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_foodServiceChargePercentage.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Liquor Service Percentage',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _liquorServiceChargePercentage.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _liquorServiceChargePercentage,
              decoration: InputDecoration(
                  hintText: 'Food Service Charge Percentage',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.design_services,
                  ),
                  suffix: Text(
                    '% ',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['liquor_service_charge_percent'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_liquorServiceChargePercentage.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Airport Delivery Charges',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _airportDeliveryCharge.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _airportDeliveryCharge,
              decoration: InputDecoration(
                  hintText: 'Airport Delivery Charge',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.airplanemode_active,
                  ),
                  suffix: Text(
                    '\$ ',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['airport_delivery_charge'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_airportDeliveryCharge.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Railway Delivery Charges',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _railwayDeliveryCharge.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _railwayDeliveryCharge,
              decoration: InputDecoration(
                  hintText: 'Railway Delivery Charge',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.directions_railway,
                  ),
                  suffix: Text(
                    '\$ ',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['railway_delivery_charge'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_railwayDeliveryCharge.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Minimum Order Price',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _minimumOrderPrice.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _minimumOrderPrice,
              decoration: InputDecoration(
                  hintText: 'Minimum Order Price',
                  border: InputBorder.none,
                  suffix: Text(
                    '\$ ',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['minimum_order_price'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_minimumOrderPrice.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Taxes',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _taxesPrice.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _taxesPrice,
              decoration: InputDecoration(
                  hintText: 'Taxes',
                  border: InputBorder.none,
                  suffix: Text(
                    '\%',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['taxes'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_taxesPrice.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin + 10),
          child: Text(
            'Surcharge',
            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _surChargePrice.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _surChargePrice,
              decoration: InputDecoration(
                  hintText: 'Sur Charge',
                  border: InputBorder.none,
                  suffix: Text(
                    '\$ ',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 18, fontColor: Colors.black),
                  )),
              onSaved: (newValue) {
                _data['surcharge'] = num.parse(newValue!.trim()).toDouble();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_surChargePrice.text == '' && validate)
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
          ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  bool isFormValid() {
    return _liquorServiceChargePercentage.text != '' && _foodServiceChargePercentage.text != '' && _airportDeliveryCharge.text != '' && _railwayDeliveryCharge.text != '' && _minimumOrderPrice.text != '' && _taxesPrice.text != '' && _surChargePrice.text != '';
  }
}
