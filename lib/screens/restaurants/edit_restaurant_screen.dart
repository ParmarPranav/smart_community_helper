import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:food_hunt_admin_app/bloc/restaurant/edit_restaurant/edit_restaurant_bloc.dart';
import 'package:food_hunt_admin_app/models/local_working_hour_timings.dart';
import 'package:food_hunt_admin_app/models/place.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/location_helper.dart';
import 'package:food_hunt_admin_app/utils/validators.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:food_hunt_admin_app/widgets/location_input.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/local_working_hours.dart';
import '../../utils/project_constant.dart';
import '../../widgets/restaurant/edit_working_hours_widget.dart';
import '../crop_image_web_screen.dart';
import '../responsive_layout.dart';

class EditRestaurantScreen extends StatefulWidget {
  EditRestaurantScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-restaurant";

  @override
  _EditRestaurantScreenState createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditRestaurantBloc _editRestaurantBloc = EditRestaurantBloc();
  bool validate = false;

  List<LocalWorkingHours> _localWorkingHoursList = [];
  List<LocalWorkingHourTimings> _removedLocalWorkingHoursTimingsList = [];

  List<Map<String, String>> _restaurantTypeList = [
    {
      'title': 'Food',
      'value': 'food',
    },
    {
      'title': 'Food & Liquor',
      'value': 'food_liquor',
    }
  ];

  Map<String, dynamic> _data = {
    'email_id': '',
    'name': '',
    'description': '',
    'restaurant_type': '',
    'mobile_no': '',
    'landline_no': '',
    'address': '',
    'city': '',
    'state': '',
    'country': '',
    'pincode': '',
    'current_location': '',
    'latitude': '',
    'longitude': '',
    'is_cash_payment': '',
    'is_online_payment': '',
    'business_logo': '',
    'old_business_logo': '',
    'cover_photo': '',
    'old_cover_photo': '',
    'photo_gallery': [],
    'old_photo_gallery': [],
    'removed_photo_gallery': [],
  };

  final picker = ImagePicker();
  dynamic _coverPhoto;
  String _oldCoverPhoto = '';
  dynamic _businessLogo;
  String _oldBusinessLogo = '';
  List<dynamic> _photoGalleyList = [];
  List<String> _removedPhotoGalleyList = [];

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _mobileNoController = TextEditingController();
  var _landlineNoController = TextEditingController();
  var _addressController = TextEditingController();
  var _cityController = TextEditingController();
  var _stateController = TextEditingController();
  var _zipCodeController = TextEditingController();

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
    _cityController.text = city;
    debugPrint('My Current City: $city');
    String state = await LocationHelper.getState(address_components);
    _stateController.text = state;
    debugPrint('My Current State: $state');
    String country = await LocationHelper.getCountry(address_components);
    debugPrint('My Current Country: $country');
    _data['country'] = country;
    String pinCode = await LocationHelper.getZipCode(address_components);
    _zipCodeController.text = pinCode;
    debugPrint('My Current Zipcode: $pinCode');
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
      final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
      _data = {
        'email_id': restaurant.emailId,
        'name': restaurant.name,
        'description': restaurant.description,
        'restaurant_type': restaurant.restaurantType,
        'mobile_no': restaurant.mobileNo,
        'landline_no': restaurant.landlineNo,
        'address': restaurant.address,
        'city': restaurant.city,
        'state': restaurant.state,
        'country': restaurant.country,
        'pincode': restaurant.pincode,
        'current_location': restaurant.currentLocation,
        'latitude': restaurant.latitude,
        'longitude': restaurant.longitude,
        'is_cash_payment': restaurant.isCashPayment,
        'is_online_payment': restaurant.isOnlinePayment,
        'business_logo': '',
        'old_business_logo': restaurant.businessLogo,
        'cover_photo': '',
        'old_cover_photo': restaurant.coverPhoto,
        'photo_gallery': [],
        'old_photo_gallery': restaurant.photoGallery,
        'removed_photo_gallery': [],
      };
      _nameController.text = restaurant.name;
      _emailController.text = restaurant.emailId;
      _descriptionController.text = restaurant.description;
      _mobileNoController.text = restaurant.mobileNo;
      _landlineNoController.text = restaurant.landlineNo;
      _addressController.text = restaurant.address;
      _cityController.text = restaurant.city;
      _stateController.text = restaurant.state;
      _zipCodeController.text = restaurant.pincode;
      _currentLocation = PlaceLocation(
        latitude: restaurant.latitude,
        longitude: restaurant.longitude,
        address: restaurant.currentLocation,
      );
      _oldCoverPhoto = restaurant.coverPhoto;
      _oldBusinessLogo = restaurant.businessLogo;
      restaurant.photoGallery.forEach((element) {
        _photoGalleyList.add(element);
      });
      print('Photo Gallery');
      print(_photoGalleyList.length);
      _localWorkingHoursList = restaurant.workingHourList.map((e) {
        return LocalWorkingHours(
          id: e.id,
          day: e.day,
          localWorkingHourTimingsList: e.workingHoursTimingsList.map((e2) {
            return LocalWorkingHourTimings(
              id: e2.id,
              workingHourId: e2.workingHourId,
              openTime: e2.openTime,
              closeTime: e2.closeTime,
              isOpened: e2.isOpened,
            );
          }).toList(),
        );
      }).toList();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditRestaurantBloc, EditRestaurantState>(
      bloc: _editRestaurantBloc,
      listener: (context, state) {
        if (state is EditRestaurantSuccessState) {
          Navigator.of(context).pop(state.restaurant);
        } else if (state is EditRestaurantFailureState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is EditRestaurantExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: state is EditRestaurantLoadingState
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
                'Edit Restaurant',
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
                _restaurantTypeDropDownWidget(),
                SizedBox(
                  height: 10,
                ),
                _emailInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _descriptionInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _mobileNoInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _landlineInputWidget(),
                SizedBox(
                  height: 15,
                ),
                _googleMapAddressWidget(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
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
                    'RESTAURANT MEDIA',
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
                _buildBusinessLogoWidget(),
                SizedBox(
                  height: 30,
                ),
                _buildCoverPhotoWidget(),
                SizedBox(
                  height: 30,
                ),
                _buildPhotoGalleryWidget(),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
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
                    'WORKING HOURS',
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
                ListView.separated(
                  itemCount: _localWorkingHoursList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return EditWorkingHourWidget(
                      index: index,
                      workingHour: _localWorkingHoursList[index],
                      addCallBack: (index) {
                        var workingHours = _localWorkingHoursList.removeAt(index);
                        setState(() {
                          _localWorkingHoursList.insert(
                            index,
                            LocalWorkingHours(
                              id: workingHours.id,
                              day: workingHours.day,
                              localWorkingHourTimingsList: workingHours.localWorkingHourTimingsList
                                ..add(
                                  LocalWorkingHourTimings(
                                    id: 0,
                                    workingHourId: 0,
                                    openTime: '',
                                    closeTime: '',
                                    isOpened: 'yes',
                                  ),
                                ),
                            ),
                          );
                        });
                      },
                      deleteCallBack: (index, subIndex) {
                        setState(() {
                          var localWorkingHourTimings = _localWorkingHoursList[index].localWorkingHourTimingsList.removeAt(subIndex);
                          if (localWorkingHourTimings.id != 0) {
                            _removedLocalWorkingHoursTimingsList.add(localWorkingHourTimings);
                          }
                        });
                      },
                      timeCallBack: (workingHour, index) {
                        setState(() {
                          _localWorkingHoursList.removeAt(index);
                          _localWorkingHoursList.insert(index, workingHour);
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
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
                    'PAYMENT METHOD',
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
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade700,
                    child: Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Cash',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  trailing: Checkbox(
                    value: _data['is_cash_payment'] == '1',
                    onChanged: (value) {
                      setState(() {
                        _data['is_cash_payment'] = value! ? '1' : '0';
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange.shade700,
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Credit Card/Debit Card/eWallet',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  trailing: Checkbox(
                    value: _data['is_online_payment'] == '1',
                    onChanged: (value) {
                      setState(() {
                        _data['is_online_payment'] = value! ? '1' : '0';
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                if (_currentLocation == null) {
                  _showSnackMessage('Please select your location', Colors.red.shade700);
                  return;
                }
                _formKey.currentState!.save();
                _data['current_location'] = _currentLocation!.address!;
                _data['latitude'] = _currentLocation!.latitude.toString();
                _data['longitude'] = _currentLocation!.longitude.toString();

                if (_businessLogo != null) _data['business_logo'] = _businessLogo is PickedFile ? base64Encode(await _businessLogo.readAsBytes()) : base64Encode(_businessLogo as Uint8List);
                if (_coverPhoto != null) _data['cover_photo'] = _coverPhoto is PickedFile ? base64Encode(await _coverPhoto.readAsBytes()) : base64Encode(_coverPhoto);

                List<dynamic> _finalPhotoGalleryList = [];
                List<String> _oldPhotoGalleryList = [];
                for (int i = 0; i < _photoGalleyList.length; i++) {
                  if (_photoGalleyList[i] is PickedFile) {
                    _finalPhotoGalleryList.add(base64Encode(await _photoGalleyList[i].readAsBytes()));
                  } else if (_photoGalleyList[i] is Uint8List) {
                    _finalPhotoGalleryList.add(_photoGalleyList[i] as Uint8List);
                  } else {
                    _oldPhotoGalleryList.add(_photoGalleyList[i] as String);
                  }
                }
                _data['photo_gallery'] = _finalPhotoGalleryList;
                _data['old_photo_gallery'] = _oldPhotoGalleryList;
                _data['removed_photo_gallery'] = _removedPhotoGalleyList;
                _data['working_hours_list'] = _localWorkingHoursList.map((e) => e.toJson()).toList();
                _data['removed_working_hours_timings_arr'] = _removedLocalWorkingHoursTimingsList.map((e) => e.toJson()).toList();
                _editRestaurantBloc.add(EditRestaurantEditEvent(editRestaurantData: _data));
              },
              child: Text(
                'UPDATE',
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

  Column _landlineInputWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
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
              controller: _landlineNoController,
              decoration: InputDecoration(
                hintText: 'Landline No',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.phone,
                ),
              ),
              onSaved: (newValue) {
                _data['landline_no'] = newValue!.trim();
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
      ],
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

  Column _descriptionInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _descriptionController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.description_outlined,
                ),
              ),
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onSaved: (newValue) {
                _data['description'] = newValue!.trim();
              },
            ),
          ),
        ),
        if (_descriptionController.text == '' && validate)
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
              showCursor: false,
              readOnly: true,
              autofocus: false,
              onSaved: (newValue) {
                _data['email_id'] = newValue!.trim();
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
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'City',
                      prefixIcon: Icon(Icons.location_on),
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    showCursor: false,
                    onSaved: (value) {
                      _data['city'] = value!.trim();
                    },
                  ),
                ),
              ),
            ),
            if (_cityController.text == '' && validate)
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
                    controller: _stateController,
                    decoration: InputDecoration(
                      hintText: 'State/Province',
                      prefixIcon: Icon(Icons.location_on),
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    showCursor: false,
                    onSaved: (value) {
                      _data['state'] = value!.trim();
                    },
                  ),
                ),
              ),
            ),
            if (_stateController.text == '' && validate)
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
                    controller: _zipCodeController,
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Zip Code',
                      prefixIcon: Icon(Icons.location_on),
                      border: InputBorder.none,
                    ),
                    onSaved: (value) {
                      _data['pincode'] = value!.trim();
                    },
                  ),
                ),
              ),
            ),
            if (_zipCodeController.text == '' && validate)
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
          height: spacingHeight * 2,
        ),
      ],
    );
  }

  Column _restaurantTypeDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _data['restaurant_type'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
                hintText: 'Restaurant Type',
                prefixIcon: Icon(Icons.restaurant),
                border: InputBorder.none,
              ),
              value: _restaurantTypeList.firstWhere((element) => element['value'] == _data['restaurant_type']),
              items: _restaurantTypeList.map((productType) {
                return DropdownMenuItem<Map<String, String>>(
                  value: productType,
                  child: Text(
                    productType['title'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onSaved: (newValue) {
                _data['restaurant_type'] = newValue!['value']!.trim();
              },
              onChanged: (value) {
                _data['restaurant_type'] = value!['value']!.trim();
              },
            ),
          ),
        ),
        if (_data['restaurant_type'] == '' && validate)
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

  Widget _buildBusinessLogoWidget() {
    if (_oldBusinessLogo != '' && _businessLogo == null) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                  if (imageFile != null) {
                    Uint8List imageData = await imageFile.readAsBytes();
                    Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                      if (value != null) {
                        setState(() {
                          _businessLogo = value as dynamic;
                        });
                      } else {
                        setState(() {
                          _businessLogo = imageFile;
                        });
                      }
                    });
                  }
                },
                icon: Icon(
                  Icons.change_circle,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 20),
              Text('BUSINESS LOGO'),
              SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  setState(() {
                    _oldBusinessLogo = '';
                  });
                },
                icon: Icon(
                  Icons.delete,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
          SizedBox(height: 5),
          Container(
            decoration: DottedDecoration(shape: Shape.circle),
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 85,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(85),
                child: CachedNetworkImage(
                  imageUrl: './${_oldBusinessLogo}',
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_oldBusinessLogo == '' && _businessLogo == null) {
      return Column(
        children: [
          Container(
            decoration: DottedDecoration(
              shape: Shape.circle,
              color: (_oldBusinessLogo != '' || _businessLogo != null) && validate ? Colors.red : Colors.grey.shade800,
            ),
            padding: EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                if (imageFile != null) {
                  Uint8List imageData = await imageFile.readAsBytes();
                  Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                    if (value != null) {
                      setState(() {
                        _businessLogo = value as dynamic;
                      });
                    } else {
                      setState(() {
                        _businessLogo = imageFile;
                      });
                    }
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.black),
                ),
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.black,
                  size: 45,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text('BUSINESS LOGO'),
          if ((_oldBusinessLogo != '' || _businessLogo != null) && validate)
            Container(
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    'Please select your business logo !!',
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
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_businessLogo != null)
                IconButton(
                  onPressed: () async {
                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                    if (imageFile != null) {
                      Uint8List imageData = await imageFile.readAsBytes();
                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                        if (value != null) {
                          setState(() {
                            _businessLogo = value as dynamic;
                          });
                        } else {
                          setState(() {
                            _businessLogo = imageFile;
                          });
                        }
                      });
                    }
                  },
                  icon: Icon(
                    Icons.change_circle,
                    size: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              SizedBox(width: 20),
              Text('BUSINESS LOGO'),
              SizedBox(width: 20),
              if (_businessLogo != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _businessLogo = null;
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                )
            ],
          ),
          SizedBox(height: 5),
          Container(
            decoration: DottedDecoration(shape: Shape.circle),
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 85,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(85),
                child: _businessLogo is PickedFile
                    ? Image.network(
                        (_businessLogo as PickedFile).path,
                        height: 170,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        _businessLogo as Uint8List,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCoverPhotoWidget() {
    if (_oldCoverPhoto != '' && _coverPhoto == null) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                    if (imageFile != null) {
                      Uint8List imageData = await imageFile.readAsBytes();
                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                        if (value != null) {
                          setState(() {
                            _coverPhoto = value as dynamic;
                          });
                        } else {
                          setState(() {
                            _coverPhoto = imageFile;
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
                    'COVER PHOTO',
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _oldCoverPhoto = '';
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
              child: CachedNetworkImage(
                imageUrl: './${_oldCoverPhoto}',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    } else if (_oldCoverPhoto == '' && _coverPhoto == null) {
      return Container(
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
                    _coverPhoto = value as dynamic;
                  });
                } else {
                  setState(() {
                    _coverPhoto = imageFile;
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
                    color: (_oldCoverPhoto != '' || _coverPhoto != null) && validate ? Colors.red : Colors.grey.shade800,
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
                  'COVER PHOTO',
                ),
                if ((_oldCoverPhoto != '' || _coverPhoto != null) && validate)
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
      );
    } else {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                if (_coverPhoto != null)
                  IconButton(
                    onPressed: () async {
                      PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                      if (imageFile != null) {
                        Uint8List imageData = await imageFile.readAsBytes();
                        Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                          if (value != null) {
                            setState(() {
                              _coverPhoto = value as dynamic;
                            });
                          } else {
                            setState(() {
                              _coverPhoto = imageFile;
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
                    'COVER PHOTO',
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_coverPhoto != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _coverPhoto = null;
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
              child: _coverPhoto is PickedFile
                  ? Image.network(
                      (_coverPhoto as PickedFile).path,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      _coverPhoto as Uint8List,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      );
    }
  }

  Column _buildPhotoGalleryWidget() {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () async {
            PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
            if (imageFile != null) {
              setState(() {
                _photoGalleyList.add(imageFile);
              });
            }
          },
          label: Text(
            'PHOTO GALLERY',
            style: TextStyle(color: Colors.black),
          ),
          icon: Icon(
            Icons.add_a_photo,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ListView.separated(
          itemCount: _photoGalleyList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Dismissible(
                key: ValueKey(index),
                background: Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.delete, color: Colors.white),
                          Text('Delete Item', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  setState(() {
                    dynamic photo = _photoGalleyList.removeAt(index);
                    if (photo is String) {
                      _removedPhotoGalleyList.add(photo);
                    }
                  });
                },
                confirmDismiss: (direction) async {
                  return await showDialog<bool?>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text("Delete Confirmation"),
                        content: const Text("Are you sure you want to delete this item ?"),
                        actions: <Widget>[
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete")),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: _photoGalleyList[index] is String
                                      ? CachedNetworkImage(
                                          imageUrl: '${_photoGalleyList[index]}',
                                          fit: BoxFit.cover,
                                        )
                                      : _photoGalleyList[index] is PickedFile
                                          ? Image.network(
                                              (_photoGalleyList[index] as PickedFile).path,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              _photoGalleyList[index] as Uint8List,
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Image ${index + 1}',
                                style: TextStyle(color: Colors.black),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {},
                              icon: Icon(
                                Icons.remove_red_eye,
                                size: 18,
                                color: Colors.red,
                              ),
                            ),
                            if (_photoGalleyList[index] is! String)
                              IconButton(
                                onPressed: () async {
                                  Uint8List imageData;
                                  if (_photoGalleyList[index] is PickedFile) {
                                    imageData = await (_photoGalleyList[index] as PickedFile).readAsBytes();
                                  } else {
                                    imageData = _photoGalleyList[index] as Uint8List;
                                  }
                                  Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _photoGalleyList[index] = value as dynamic;
                                      });
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.crop,
                                  size: 18,
                                  color: Colors.red,
                                ),
                              ),
                            IconButton(
                              onPressed: () async {
                                bool? isDelete = await showDialog<bool?>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: const Text("Delete Confirmation"),
                                      content: const Text("Are you sure you want to delete this item ?"),
                                      actions: <Widget>[
                                        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete")),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (isDelete!) {
                                  setState(() {
                                    dynamic photo = _photoGalleyList.removeAt(index);
                                    if (photo is String) {
                                      _removedPhotoGalleyList.add(photo);
                                    }
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        ),
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
    return _nameController.text != '' &&
        _data['restaurant_type'] != '' &&
        _emailController.text != '' &&
        _descriptionController.text != '' &&
        _mobileNoController.text != '' &&
        _addressController.text != '' &&
        _cityController.text != '' &&
        _stateController.text != '' &&
        _zipCodeController.text != '' &&
        _currentLocation != null &&
        (_oldCoverPhoto != '' || _coverPhoto != null) &&
        (_oldBusinessLogo != '' || _businessLogo != null) &&
        Validators.isValidEmail(_emailController.text);
  }
}
