import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:food_hunt_admin_app/models/users.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:intl/intl.dart';

import '../../bloc/coupon/add_coupon/add_coupon_bloc.dart';
import '../../bloc/coupon/get_users_list/get_users_list_bloc.dart';
import '../responsive_layout.dart';

class AddCouponScreen extends StatefulWidget {
  static const routeName = "/add-coupon";

  @override
  _AddCouponScreenState createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddCouponBloc _addCouponBloc = AddCouponBloc();
  final GetUsersListBloc _getUsersListBloc = GetUsersListBloc();
  bool validate = false;

  List<Users> _usersList = [];

  Map<String, dynamic> _data = {
    'coupon_code': '',
    'coupon_title': '',
    'coupon_subtitle': '',
    'validity_end': '',
    'discount_calculation_type': '',
    'discount_type': '',
    'discount_value': 0.0,
    'minimum_order_price': 0.0,
    'maximum_discount_price': 0.0,
    'no_of_time_use': 0,
    'user_type': '',
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
  List<Map<String, String>> _userTypeList = [
    {
      'title': 'All',
      'value': 'all',
    },
    {
      'title': 'Specific',
      'value': 'specific',
    }
  ];
  DateTime? _validityEndDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getUsersListBloc.add(GetUsersListDataEvent());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetUsersListBloc, GetUsersListState>(
      bloc: _getUsersListBloc,
      listener: (context, state) {
        if (state is GetUsersListSuccessState) {
          _usersList = state.usersList;
        } else if (state is GetUsersListFailedState) {
          _usersList = state.usersList;
        } else if (state is GetUsersListExceptionState) {
          _usersList = state.usersList;
        }
      },
      builder: (context, state) {
        return state is GetUsersListLoadingState
            ? Center(
                child: CircularProgressIndicator(),
              )
            : BlocConsumer<AddCouponBloc, AddCouponState>(
                bloc: _addCouponBloc,
                listener: (context, state) {
                  if (state is AddCouponSuccessState) {
                    Navigator.of(context).pop(state.coupon);
                  } else if (state is AddCouponFailureState) {
                    _showSnackMessage(state.message, Colors.red.shade700);
                  } else if (state is AddCouponExceptionState) {
                    _showSnackMessage(state.message, Colors.red.shade700);
                  }
                },
                builder: (context, state) {
                  return SafeArea(
                    child: Scaffold(
                      body: Form(
                        key: _formKey,
                        child: state is AddCouponLoadingState
                            ? CircularProgressIndicator()
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
                'Add Coupon',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                _userTypeInputWidget(),
                SizedBox(
                  height: 10,
                ),
                if (_data['user_type'] == 'specific')
                  Column(
                    children: [
                      _userChipsInputWidget(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
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
                _formKey.currentState!.save();
                _addCouponBloc.add(
                  AddCouponAddEvent(addCouponData: _data),
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
              decoration: InputDecoration(
                hintText: 'Discount Calculation Type',
                prefixIcon: Icon(Icons.calculate),
                border: InputBorder.none,
              ),
              items: _discountCalculationTypeList.map((dicountCalculationType) {
                return DropdownMenuItem<Map<String, String>>(
                  value: dicountCalculationType,
                  child: Text(
                    dicountCalculationType['title'] ?? '',
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

  Column _userTypeInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _data['user_type'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
              decoration: InputDecoration(
                hintText: 'User Type',
                prefixIcon: Icon(Icons.people),
                border: InputBorder.none,
              ),
              items: _userTypeList.map((userType) {
                return DropdownMenuItem<Map<String, String>>(
                  value: userType,
                  child: Text(
                    userType['title'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onSaved: (newValue) {
                _data['user_type'] = newValue!['value'];
              },
              onChanged: (value) {
                setState(() {
                  _data['user_type'] = value!['value'];
                });
              },
            ),
          ),
        ),
        if (_data['user_type'] == '' && validate)
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

  Container _userChipsInputWidget() {
    return Container(
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
        child: ChipsInput<Users>(
          key: _chipKey,
          maxChips: _usersList.length,
          initialSuggestions: _usersList,
          decoration: InputDecoration(
            hintText: "Select Users",
            prefixIcon: Icon(Icons.people),
            hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.grey.shade500,
            ),
            border: InputBorder.none,
          ),
          findSuggestions: (String query) {
            if (query.isNotEmpty) {
              var lowercaseQuery = query.toLowerCase();
              return _usersList.where((profile) {
                return profile.name.toLowerCase().contains(query.toLowerCase()) || profile.email.toLowerCase().contains(query.toLowerCase());
              }).toList(growable: false)
                ..sort((a, b) => a.name.toLowerCase().indexOf(lowercaseQuery).compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
            }
            return _usersList;
          },
          onChanged: (data) {
            print(data);
          },
          chipBuilder: (context, state, profile) {
            return InputChip(
              key: ObjectKey(profile),
              label: Text(profile.name),
              avatar: CircleAvatar(
                child: Text('${profile.name.substring(0, 1).toUpperCase()}'),
              ),
              onDeleted: () => state.deleteChip(profile),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          },
          suggestionBuilder: (ctx, state, profile) {
            return ListTile(
              key: ObjectKey(profile),
              leading: CircleAvatar(
                child: Text('${profile.name.substring(0, 1).toUpperCase()}'),
              ),
              title: Text(profile.name),
              subtitle: Text(profile.email),
              onTap: () => state.selectSuggestion(profile),
            );
          },
          autofocus: true,
        ),
      ),
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
