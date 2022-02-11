import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:food_hunt_admin_app/bloc/coupon/edit_coupon/edit_coupon_bloc.dart';
import 'package:food_hunt_admin_app/models/coupon.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:intl/intl.dart';

import '../responsive_layout.dart';

class EditCouponScreen extends StatefulWidget {
  static const routeName = "/edit-coupon";

  @override
  _EditCouponScreenState createState() => _EditCouponScreenState();
}

class _EditCouponScreenState extends State<EditCouponScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditCouponBloc _editCouponBloc = EditCouponBloc();
  bool validate = false;

  Coupon? coupon;

  Map<String, dynamic> _data = {
    'id': 0,
    'coupon_title': '',
    'coupon_subtitle': '',
    'validity_end': '',
    'discount_calculation_type': '',
    'discount_type': '',
    'discount_value': 0.0,
    'minimum_order_price': 0.0,
    'maximum_discount_price': 0.0,
    'no_of_time_use': 0,
  };
  final _chipKey = GlobalKey<ChipsInputState>();
  var _couponTitleController = TextEditingController();
  var _couponSubtitleController = TextEditingController();
  var _couponCodeController = TextEditingController();
  var _discountValueController = TextEditingController();
  var _minimumOrderPriceController = TextEditingController();
  var _maximumDiscountPriceController = TextEditingController();
  var _noOfTimeUseController = TextEditingController();
  var _validityEndController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  List<Map<String, String>> _discountCalculationTypeList = [
    {
      'title': 'Flat',
      'value': 'flat',
    },
    {
      'title': 'Upto',
      'value': 'upto',
    }
  ];
  List<Map<String, String>> _discountTypeList = [
    {
      'title': 'Percentage',
      'value': 'percentage',
    },
    {
      'title': 'Amount',
      'value': 'amount',
    }
  ];

  DateTime? _validityEndDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      coupon = ModalRoute.of(context)!.settings.arguments as Coupon;
      _couponTitleController.text = coupon!.couponTitle;
      _couponSubtitleController.text = coupon!.couponSubtitle;
      _couponCodeController.text = coupon!.couponCode;
      _discountValueController.text = coupon!.discountValue.toString();
      _minimumOrderPriceController.text = coupon!.minimumOrderPrice.toString();
      _maximumDiscountPriceController.text = coupon!.maximumDiscountPrice.toString();
      _noOfTimeUseController.text = coupon!.noOfTimeUse.toString();
      _validityEndDate = coupon!.validityEnd;
      _validityEndController.text = DateFormat("dd MMMM yyyy").format(coupon!.validityEnd);
      _data['id'] = coupon!.id;
      _data['discount_calculation_type'] = coupon!.discountCalculationType;
      _data['discount_type'] = coupon!.discountType;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditCouponBloc, EditCouponState>(
      bloc: _editCouponBloc,
      listener: (context, state) {
        if (state is EditCouponSuccessState) {
          Navigator.of(context).pop(state.coupon);
        } else if (state is EditCouponFailureState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is EditCouponExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: state is EditCouponLoadingState
                  ? Center(child: CircularProgressIndicator())
                  : ResponsiveLayout(
                      smallScreen: _bodyWidget(),
                      mediumScreen: _bodyWidget(),
                      largeScreen: _bodyWidget(),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _bodyWidget() {
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
                'Edit Coupon',
                style: ProjectConstant.WorkSansFontBoldTextStyle(
                  fontSize: 20,
                  fontColor: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            decoration: DottedDecoration(
              shape: Shape.box,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                _couponTitleInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _couponSubtitleInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _couponCodeInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _discountCalculationTypeInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _discountTypeInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _discountValueInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _minimumOrderPriceInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _maximumDiscountPriceInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _noOfTimeUseInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _validityEndsInputWidget(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 500,
            height: 55,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  validate = true;
                });
                if (!isFormValid()) {
                  return;
                }
                _data['id'] = coupon!.id;
                _formKey.currentState!.save();
                _editCouponBloc.add(
                  EditCouponAddEvent(editCouponData: _data),
                );
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(containerRadius),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Column _couponTitleInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _couponTitleController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _couponTitleController,
              decoration: InputDecoration(
                hintText: 'Coupon Title',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.title),
              ),
              onSaved: (newValue) {
                _data['coupon_title'] = newValue!.trim();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_couponTitleController.text == '' && validate)
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

  Column _couponSubtitleInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _couponSubtitleController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _couponSubtitleController,
              decoration: InputDecoration(
                hintText: 'Coupon Subtitle',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.subject),
              ),
              onSaved: (newValue) {
                _data['coupon_subtitle'] = newValue!.trim();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_couponSubtitleController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                 Text(
                  'Required Field !!',
                  style: ProjectConstant.WorkSansFontRegularTextStyle(
                    fontSize: 12,
                    fontColor: Colors.red,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  Column _couponCodeInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _couponCodeController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _couponCodeController,
              decoration: InputDecoration(
                hintText: 'Coupon Code',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.wysiwyg),
              ),
              onSaved: (newValue) {
                _data['coupon_code'] = newValue!.trim();
              },
              readOnly: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_couponSubtitleController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                 Text(
                  'Required Field !!',
                  style: ProjectConstant.WorkSansFontRegularTextStyle(
                    fontSize: 12,
                    fontColor: Colors.red,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  Column _discountCalculationTypeInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _data['discount_calculation_type'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
            child: DropdownButtonFormField<Map<String, String>>(
              value: _discountCalculationTypeList.firstWhere((element) => element['value'] == _data['discount_calculation_type']),
              decoration: InputDecoration(
                hintText: 'Discount Calculation Type',
                prefixIcon: Icon(Icons.calculate),
                border: InputBorder.none,
              ),
              items: _discountCalculationTypeList.map((discountCalculationType) {
                return DropdownMenuItem<Map<String, String>>(
                  value: discountCalculationType,
                  child: Text(
                    discountCalculationType['title'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onSaved: (newValue) {
                _data['discount_calculation_type'] = newValue!['value'];
              },
              onChanged: (value) {
                _data['discount_calculation_type'] = value!['value'];
              },
            ),
          ),
        ),
        if (_data['discount_calculation_type'] == '' && validate)
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

  Column _discountTypeInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _data['discount_type'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
            child: DropdownButtonFormField<Map<String, String>>(
              value: _discountTypeList.firstWhere((element) => element['value'] == _data['discount_type']),
              decoration: InputDecoration(
                hintText: 'Discount Type',
                prefixIcon: Icon(Icons.local_offer),
                border: InputBorder.none,
              ),
              items: _discountTypeList.map((discountType) {
                return DropdownMenuItem<Map<String, String>>(
                  value: discountType,
                  child: Text(
                    discountType['title'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onSaved: (newValue) {
                _data['discount_type'] = newValue!['value'];
              },
              onChanged: (value) {
                _data['discount_type'] = value!['value'];
              },
            ),
          ),
        ),
        if (_data['discount_type'] == '' && validate)
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

  Column _discountValueInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _discountValueController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _discountValueController,
              decoration: InputDecoration(
                hintText: 'Discount Value',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.local_offer,
                ),
              ),
              onSaved: (newValue) {
                _data['discount_value'] = newValue != null ? num.parse(newValue.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_discountValueController.text == '' && validate)
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

  Column _minimumOrderPriceInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _minimumOrderPriceController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _minimumOrderPriceController,
              decoration: InputDecoration(
                hintText: 'Minimum Order Price',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              onSaved: (newValue) {
                _data['minimum_order_price'] = newValue != null ? num.parse(newValue.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_minimumOrderPriceController.text == '' && validate)
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

  Column _maximumDiscountPriceInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _maximumDiscountPriceController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _maximumDiscountPriceController,
              decoration: InputDecoration(
                hintText: 'Maximum Discount Price',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              onSaved: (newValue) {
                _data['maximum_discount_price'] = newValue != null ? num.parse(newValue.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_maximumDiscountPriceController.text == '' && validate)
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

  Column _noOfTimeUseInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _noOfTimeUseController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _noOfTimeUseController,
              decoration: InputDecoration(
                hintText: 'No. of Usable Times',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.add_to_photos,
                ),
              ),
              onSaved: (newValue) {
                _data['no_of_time_use'] = newValue != null ? num.parse(newValue.trim()).toInt() : 0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_noOfTimeUseController.text == '' && validate)
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

  Column _validityEndsInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _validityEndController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _validityEndController,
              decoration: InputDecoration(
                hintText: 'Validity Ends At',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.event,
                ),
              ),
              showCursor: false,
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate == null) {
                  return;
                }
                setState(() {
                  _validityEndDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                  _validityEndController.text = DateFormat("dd MMMM yyyy").format(selectedDate);
                });
              },
              onSaved: (newValue) {
                _data['validity_end'] = DateFormat("yyyy-MM-dd HH:mm:ss").format(_validityEndDate!);
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_validityEndController.text == '' && validate)
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
    return _couponTitleController.text != '' &&
        _couponSubtitleController.text != '' &&
        _couponCodeController.text != '' &&
        _discountValueController.text != '' &&
        _minimumOrderPriceController.text != '' &&
        _maximumDiscountPriceController.text != '' &&
        _noOfTimeUseController.text != '' &&
        _data['discount_calculation_type'] != '' &&
        _data['discount_type'] != '' &&
        _data['user_type'] != '';
  }
}
