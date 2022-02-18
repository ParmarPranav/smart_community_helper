import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:food_hunt_admin_app/models/place.dart';
import 'package:food_hunt_admin_app/utils/location_helper.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/utils/validators.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:food_hunt_admin_app/widgets/location_input.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/delivery_boy/add_delivery_boy/add_delivery_boy_blocs.dart';
import '../../bloc/register_city/get_register_city/get_register_city_bloc.dart';
import '../../models/register_city.dart';
import '../crop_image_web_screen.dart';
import '../responsive_layout.dart';

class AddDeliveryBoyScreen extends StatefulWidget {
  const AddDeliveryBoyScreen({Key? key}) : super(key: key);

  static const routeName = "/add-delivery-boy";

  @override
  _AddDeliveryBoyScreenState createState() => _AddDeliveryBoyScreenState();
}

class _AddDeliveryBoyScreenState extends State<AddDeliveryBoyScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<RegisterCity> _registerCity = [];
  final GetRegisterCityBloc _getRegisterCityBloc = GetRegisterCityBloc();

  AddDeliveryBoyBloc _addDeliveryBoyBloc = AddDeliveryBoyBloc();
  bool validate = false;

  Map<String, dynamic> _data = {
    'register_city_id': 0,
    'name': '',
    'mobile_no': '',
    'email': '',
    'delivery_type': '',
    'address': '',
    'city': '',
    'state': '',
    'country': '',
    'current_location': '',
    'longitude': '',
    'latitude': '',
    "no_of_orders": 0,
    'vehicle_name': '',
    'vehicle_model': '',
    'vehicle_color': '',
    'registration_no': '',
    'front_regist_certi': '',
    'back_regist_certi': '',
    'driving_license_no': '',
    'driving_license_front_side': '',
    'driving_license_back_side': '',
    'liquor_license_front_side': '',
    'is_vehicle_details_approved': '',
    'is_driving_license_approved': '',
    'is_liquor_license_approved': ''
  };

  List<Map<String, String>> _deliveryTypeList = [
    {'title': 'Food', 'value': 'food'},
    {'title': 'Food & Liquor', 'value': 'food_liquor'},
  ];

  final picker = ImagePicker();
  dynamic _drivingLicenseFrontImage;
  dynamic _drivingLicenseBackImage;
  dynamic _liquorLicenseImage;
  dynamic _vehicleLicenseFrontImage;
  dynamic _vehicleLicenseBackImage;

  var _nameController = TextEditingController();
  var _noOfOrderController = TextEditingController();
  var _emailController = TextEditingController();
  var _vehicleNameController = TextEditingController();
  var _vehicleModelController = TextEditingController();
  var _vehicleColorController = TextEditingController();
  var _vehicleRegistrationNoController = TextEditingController();
  var _drivingLicenseNoController = TextEditingController();
  var _mobileNoController = TextEditingController();
  var _addressController = TextEditingController();


  PlaceLocation? _currentLocation;

  void _selectLocation(PlaceLocation placeLocation) async {
    setState(() {
      _currentLocation = placeLocation;
    });
    List<dynamic> address_components = await LocationHelper.getAddressComponentsList(placeLocation.latitude, placeLocation.longitude);
    String address = await LocationHelper.getAddress(address_components);
    _addressController.text = address;
    debugPrint('My Current Address: $address');
    String city = await LocationHelper.getCity(address_components);
    _data['city']  = city;
    debugPrint('My Current City: $city');
    String state = await LocationHelper.getState(address_components);
    _data['state'] = state;
    debugPrint('My Current State: $state');
    String country = await LocationHelper.getCountry(address_components);
    debugPrint('My Current Country: $country');
    _data['country'] = country;

    debugPrint('Current Location : ${_currentLocation?.address!}');
  }

  Future<PickedFile?> _getImageFromGallery(ImageSource imageSource) async {
    PickedFile? pickedFile = await picker.getImage(
      source: imageSource,
    );
    if (pickedFile != null) {
      return pickedFile;
    }
    return null;
  }

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getRegisterCityBloc.add(GetRegisterCityDataEvent());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDeliveryBoyBloc, AddDeliveryBoyState>(
      bloc: _addDeliveryBoyBloc,
      listener: (context, state) {
        if (state is AddDeliveryBoySuccessState) {
          Navigator.of(context).pop(state.deliveryBoy);
        } else if (state is AddDeliveryBoyFailureState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is AddDeliveryBoyExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: state is AddDeliveryBoyLoadingState
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
                'Add Delivery Boy',
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
                  height: 30,
                ),
                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'PERSONAL INFORMATION',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _nameInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _emailInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _mobileNoInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _noOfOrdersInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _registerCityDropDownWidget(),
                SizedBox(
                  height: 10,
                ),
                _deliveryTypeWidget(),
                SizedBox(
                  height: 10,
                ),
                _googleMapAddressWidget(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _buildDrivingLicenseWidget(),
          SizedBox(
            height: 20,
          ),
          if (_data['delivery_type'] == 'food_liquor')
            Column(
              children: [
                _buildLiquorLicenseWidget(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          _buildVehicleDetailsWidget(),
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
                if(_data['delivery_type'] == 'food_liquor'){
                  if(_liquorLicenseImage==null){
                    return;
                  }
                }
                if (_currentLocation == null) {
                  _showSnackMessage('Please select your location', Colors.red.shade700);
                  return;
                }
                _data['liquor_license_front_side'] =
                    _drivingLicenseFrontImage is PickedFile ? base64Encode(await _drivingLicenseFrontImage.readAsBytes()) : base64Encode(_drivingLicenseFrontImage as Uint8List);
                _data['driving_license_back_side'] =
                    _drivingLicenseBackImage is PickedFile ? base64Encode(await _drivingLicenseBackImage.readAsBytes()) : base64Encode(_drivingLicenseBackImage as Uint8List);
                _data['front_regist_certi'] =
                    _vehicleLicenseFrontImage is PickedFile ? base64Encode(await _vehicleLicenseFrontImage.readAsBytes()) : base64Encode(_vehicleLicenseFrontImage as Uint8List);
                _data['back_regist_certi'] = _vehicleLicenseBackImage is PickedFile ? base64Encode(await _vehicleLicenseBackImage.readAsBytes()) : base64Encode(-_vehicleLicenseBackImage as Uint8List);
                if (_liquorLicenseImage != null)
                  _data['liquor_license_front_side'] = _liquorLicenseImage is PickedFile ? base64Encode(await _liquorLicenseImage.readAsBytes()) : base64Encode(_liquorLicenseImage as Uint8List);

                _formKey.currentState!.save();
                _data['current_location'] = _currentLocation!.address!;
                _data['latitude'] = _currentLocation!.latitude.toString();
                _data['longitude'] = _currentLocation!.longitude.toString();
                _addDeliveryBoyBloc.add(AddDeliveryBoyAddEvent(addDeliveryBoyData: _data));
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

  Container _deliveryTypeWidget() {
    return Container(
      decoration: DottedDecoration(
        shape: Shape.box,
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(containerRadius),
      ),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: DropdownButtonFormField<Map<String, String>>(
        decoration: InputDecoration(labelText: 'Delivery Type', prefixIcon: Icon(Icons.delivery_dining), border: InputBorder.none),
        validator: (value) {
          if (value == null) {
            return 'Required Field';
          }
          return null;
        },
        items: _deliveryTypeList.map((deliveryType) {
          return DropdownMenuItem<Map<String, String>>(
            value: deliveryType,
            child: Text(deliveryType['title']!),
          );
        }).toList(),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          setState(() {
            _data['delivery_type'] = value!['value']!.trim();
          });
        },
        onSaved: (newValue) {
          _data['delivery_type'] = newValue!['value']!.trim();
        },
      ),
    );
  }

  Column _mobileNoInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _mobileNoController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _mobileNoController,
              decoration: InputDecoration(
                hintText: 'Mobile No',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                ),
              ),
              onSaved: (newValue) {
                _data['mobile_no'] = newValue!.trim();
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_mobileNoController.text == '' && validate)
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

  Column _emailInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _emailController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
              autofocus: false,
              onSaved: (newValue) {
                _data['email'] = newValue!.trim();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_emailController.text == '' && validate)
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
        else if (!Validators.isValidEmail(_emailController.text) && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  'Invalid email !!',
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

  Column _nameInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _nameController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.person_outlined,
                ),
              ),
              onSaved: (newValue) {
                _data['name'] = newValue!.trim();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_nameController.text == '' && validate)
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

  Column _noOfOrdersInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _noOfOrderController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _noOfOrderController,
              decoration: InputDecoration(
                hintText: 'No Of Orders',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.person_outlined,
                ),
              ),
              onSaved: (newValue) {
                _data['no_of_orders'] = newValue!.trim();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_nameController.text == '' && validate)
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

  Column _googleMapAddressWidget() {
    return Column(
      children: [
        SizedBox(height: spacingHeight),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: LocationInput(
            currentLocation: _currentLocation,
            isValidate: validate,
            selectLocationHandler: _selectLocation,
          ),
        ),
        SizedBox(height: spacingHeight),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
              child: Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(containerRadius),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius),
                    color: Colors.grey.shade100,
                  ),
                  child: TextFormField(
                    controller: _addressController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                      border: InputBorder.none,
                    ),
                    onSaved: (value) {
                      _data['address'] = value!.trim();
                    },
                  ),
                ),
              ),
            ),
            if (_addressController.text == '' && validate)
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
        ),
        SizedBox(
          height: spacingHeight,
        ),

      ],
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
        return Column(
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
                  decoration: InputDecoration(
                    hintText: 'Select City',
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
      },
    );
  }

  Widget _buildDrivingLicenseWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: DottedDecoration(
        shape: Shape.box,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            height: 35,
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'DRIVING LICENSE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: _drivingLicenseNoController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
                    controller: _drivingLicenseNoController,
                    decoration: InputDecoration(
                      hintText: 'License No',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_outlined,
                      ),
                    ),
                    onSaved: (newValue) {
                      _data['driving_license_no'] = newValue!.trim();
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              if (_drivingLicenseNoController.text == '' && validate)
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
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              _drivingLicenseFrontImage == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                          if (imageFile != null) {
                            Uint8List imageData = await imageFile.readAsBytes();
                            Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                              if (value != null) {
                                setState(() {
                                  _drivingLicenseFrontImage = value as dynamic;
                                });
                              } else {
                                setState(() {
                                  _drivingLicenseFrontImage = imageFile;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: DottedDecoration(
                                  shape: Shape.circle,
                                  color: _drivingLicenseFrontImage == null && validate ? Colors.red : Colors.grey.shade800,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Icon(
                                    FeatherIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'FRONT IMAGE',
                              ),
                              if (_drivingLicenseFrontImage == null && validate)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Please select your cover photo !!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              if (_drivingLicenseFrontImage != null)
                                IconButton(
                                  onPressed: () async {
                                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                                    if (imageFile != null) {
                                      Uint8List imageData = await imageFile.readAsBytes();
                                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _drivingLicenseFrontImage = value as dynamic;
                                          });
                                        } else {
                                          setState(() {
                                            _drivingLicenseFrontImage = imageFile;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.change_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  'FRONT IMAGE',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_drivingLicenseFrontImage != null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _drivingLicenseFrontImage = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: ResponsiveLayout.isLargeScreen(context) ? 400 : 200,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _drivingLicenseFrontImage is PickedFile
                                ? Image.network(
                                    (_drivingLicenseFrontImage as PickedFile).path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    _drivingLicenseFrontImage as Uint8List,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              _drivingLicenseBackImage == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                          if (imageFile != null) {
                            Uint8List imageData = await imageFile.readAsBytes();
                            Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                              if (value != null) {
                                setState(() {
                                  _drivingLicenseBackImage = value as dynamic;
                                });
                              } else {
                                setState(() {
                                  _drivingLicenseBackImage = imageFile;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: DottedDecoration(
                                  shape: Shape.circle,
                                  color: _drivingLicenseBackImage == null && validate ? Colors.red : Colors.grey.shade800,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Icon(
                                    FeatherIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'BACK IMAGE',
                              ),
                              if (_drivingLicenseBackImage == null && validate)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Please select your cover photo !!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              if (_drivingLicenseBackImage != null)
                                IconButton(
                                  onPressed: () async {
                                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                                    if (imageFile != null) {
                                      Uint8List imageData = await imageFile.readAsBytes();
                                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _drivingLicenseBackImage = value as dynamic;
                                          });
                                        } else {
                                          setState(() {
                                            _drivingLicenseBackImage = imageFile;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.change_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  'BACK IMAGE',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_drivingLicenseBackImage != null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _drivingLicenseBackImage = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: ResponsiveLayout.isLargeScreen(context) ? 400 : 200,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _drivingLicenseBackImage is PickedFile
                                ? Image.network(
                                    (_drivingLicenseBackImage as PickedFile).path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    _drivingLicenseBackImage as Uint8List,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Checkbox(
                    value: _data['is_driving_license_approved'] == '1',
                    onChanged: (newValue) {
                      setState(() {
                        _data['is_driving_license_approved'] = newValue! ? '1' : '0';
                      });
                    }),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'I have approved driving license',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildLiquorLicenseWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: DottedDecoration(
        shape: Shape.box,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            height: 35,
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'LIQUOR LICENSE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              _liquorLicenseImage == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                          if (imageFile != null) {
                            Uint8List imageData = await imageFile.readAsBytes();
                            Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                              if (value != null) {
                                setState(() {
                                  _liquorLicenseImage = value as dynamic;
                                });
                              } else {
                                setState(() {
                                  _liquorLicenseImage = imageFile;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: DottedDecoration(
                                  shape: Shape.circle,
                                  color: _liquorLicenseImage == null && validate ? Colors.red : Colors.grey.shade800,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Icon(
                                    FeatherIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'FRONT IMAGE',
                              ),
                              if (_liquorLicenseImage == null && validate)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Please select your cover photo !!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              if (_liquorLicenseImage != null)
                                IconButton(
                                  onPressed: () async {
                                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                                    if (imageFile != null) {
                                      Uint8List imageData = await imageFile.readAsBytes();
                                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _liquorLicenseImage = value as dynamic;
                                          });
                                        } else {
                                          setState(() {
                                            _liquorLicenseImage = imageFile;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.change_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  'FRONT IMAGE',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_liquorLicenseImage != null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _liquorLicenseImage = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: ResponsiveLayout.isLargeScreen(context) ? 400 : 200,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _liquorLicenseImage is PickedFile
                                ? Image.network(
                                    (_liquorLicenseImage as PickedFile).path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    _liquorLicenseImage as Uint8List,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Checkbox(
                    value: _data['is_liquor_license_approved'] == '1',
                    onChanged: (newValue) {
                      setState(() {
                        _data['is_liquor_license_approved'] = newValue! ? '1' : '0';
                      });
                    }),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'I have approved liquor license',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: DottedDecoration(
        shape: Shape.box,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            height: 35,
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'VEHICLE DETAILS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: _vehicleNameController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
                    controller: _vehicleNameController,
                    decoration: InputDecoration(
                      hintText: 'Vehicle Name',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_outlined,
                      ),
                    ),
                    onSaved: (newValue) {
                      _data['vehicle_name'] = newValue!.trim();
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              if (_vehicleNameController.text == '' && validate)
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
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: _vehicleModelController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
                    controller: _vehicleModelController,
                    decoration: InputDecoration(
                      hintText: 'Vehicle Model',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_outlined,
                      ),
                    ),
                    onSaved: (newValue) {
                      _data['vehicle_model'] = newValue!.trim();
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              if (_vehicleModelController.text == '' && validate)
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
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: _vehicleColorController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
                    controller: _vehicleColorController,
                    decoration: InputDecoration(
                      hintText: 'Vehicle Color',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_outlined,
                      ),
                    ),
                    onSaved: (newValue) {
                      _data['vehicle_color'] = newValue!.trim();
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              if (_vehicleColorController.text == '' && validate)
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
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: _vehicleRegistrationNoController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
                    controller: _vehicleRegistrationNoController,
                    decoration: InputDecoration(
                      hintText: 'Registration No',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_outlined,
                      ),
                    ),
                    onSaved: (newValue) {
                      _data['registration_no'] = newValue!.trim();
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              if (_vehicleRegistrationNoController.text == '' && validate)
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
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              _vehicleLicenseFrontImage == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                          if (imageFile != null) {
                            Uint8List imageData = await imageFile.readAsBytes();
                            Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                              if (value != null) {
                                setState(() {
                                  _vehicleLicenseFrontImage = value as dynamic;
                                });
                              } else {
                                setState(() {
                                  _vehicleLicenseFrontImage = imageFile;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: DottedDecoration(
                                  shape: Shape.circle,
                                  color: _vehicleLicenseFrontImage == null && validate ? Colors.red : Colors.grey.shade800,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Icon(
                                    FeatherIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'FRONT IMAGE',
                              ),
                              if (_vehicleLicenseFrontImage == null && validate)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Please select your cover photo !!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              if (_vehicleLicenseFrontImage != null)
                                IconButton(
                                  onPressed: () async {
                                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                                    if (imageFile != null) {
                                      Uint8List imageData = await imageFile.readAsBytes();
                                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _vehicleLicenseFrontImage = value as dynamic;
                                          });
                                        } else {
                                          setState(() {
                                            _vehicleLicenseFrontImage = imageFile;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.change_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  'FRONT IMAGE',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_vehicleLicenseFrontImage != null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _vehicleLicenseFrontImage = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: ResponsiveLayout.isLargeScreen(context) ? 400 : 200,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _vehicleLicenseFrontImage is PickedFile
                                ? Image.network(
                                    (_vehicleLicenseFrontImage as PickedFile).path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    _vehicleLicenseFrontImage as Uint8List,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              _vehicleLicenseBackImage == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                          if (imageFile != null) {
                            Uint8List imageData = await imageFile.readAsBytes();
                            Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                              if (value != null) {
                                setState(() {
                                  _vehicleLicenseBackImage = value as dynamic;
                                });
                              } else {
                                setState(() {
                                  _vehicleLicenseBackImage = imageFile;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: DottedDecoration(
                                  shape: Shape.circle,
                                  color: _vehicleLicenseBackImage == null && validate ? Colors.red : Colors.grey.shade800,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Icon(
                                    FeatherIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'BACK IMAGE',
                              ),
                              if (_vehicleLicenseBackImage == null && validate)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Please select your cover photo !!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              if (_vehicleLicenseBackImage != null)
                                IconButton(
                                  onPressed: () async {
                                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                                    if (imageFile != null) {
                                      Uint8List imageData = await imageFile.readAsBytes();
                                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _vehicleLicenseBackImage = value as dynamic;
                                          });
                                        } else {
                                          setState(() {
                                            _vehicleLicenseBackImage = imageFile;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.change_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  'BACK IMAGE',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_vehicleLicenseBackImage != null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _vehicleLicenseBackImage = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: ResponsiveLayout.isLargeScreen(context) ? 400 : 200,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _vehicleLicenseBackImage is PickedFile
                                ? Image.network(
                                    (_vehicleLicenseBackImage as PickedFile).path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    _vehicleLicenseBackImage as Uint8List,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Checkbox(
                    value: _data['is_vehicle_details_approved'] == '1',
                    onChanged: (newValue) {
                      setState(() {
                        _data['is_vehicle_details_approved'] = newValue! ? '1' : '0';
                      });
                    }),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'I have approved vehicle details',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
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
    return _nameController.text != '' &&
        _data['delivery_type'] != '' &&
        _data['register_city_id'] != 0 &&
        _emailController.text != '' &&
        _vehicleNameController.text != '' &&
        _mobileNoController.text != '' &&
        _addressController.text != '' &&
        _noOfOrderController.text != '' &&
        _vehicleColorController.text != '' &&
        _vehicleModelController.text != '' &&
        _drivingLicenseNoController.text != '' &&
        _vehicleRegistrationNoController.text != '' &&
        _drivingLicenseFrontImage != null &&
        _drivingLicenseBackImage != null &&
        _vehicleLicenseBackImage != null &&
        _vehicleLicenseFrontImage != null &&
        _currentLocation != null &&
        Validators.isValidEmail(_emailController.text);
  }
}
