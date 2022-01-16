import 'dart:typed_data';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:food_hunt_admin_app/models/place.dart';
import 'package:food_hunt_admin_app/utils/location_helper.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:food_hunt_admin_app/widgets/location_input.dart';
import 'package:image_picker/image_picker.dart';

import '../crop_image_web_screen.dart';
import '../responsive_layout.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({Key? key}) : super(key: key);

  static const routeName = "/add-restaurant";

  @override
  _AddRestaurantScreenState createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validate = false;
  bool isRestaurantSelected = false;
  List<String> _restaurantTypeList = ['Food', 'Food & Liquor'];

  Map<String, String> _data = {
    'email_id': '',
    'name': '',
    'description': '',
    'restaurant_type': '',
    'password': '',
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
  };

  final picker = ImagePicker();
  dynamic _coverPhoto;
  dynamic _businessLogo;
  List<dynamic> _photoGalleyList = [];

  var _passwordVisible = false;
  var _confirmPasswordVisible = false;

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _mobileNoController = TextEditingController();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ResponsiveLayout(
            smallScreen: _buildMobileTabletView(),
            mediumScreen: _buildMobileTabletView(),
            largeScreen: _buildWebView(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabletView() {
    return Container();
  }

  Widget _buildWebView() {
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
                'Add Restaurant',
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
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                    'Personal Information',
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
                _passwordInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _confirmPasswordInputWidget(),
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
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'Restaurant Media',
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
                  height: 20,
                ),
                _buildCoverPhotoWidget(),
                SizedBox(
                  height: 20,
                ),
                _buildPhotoGalleryWidget(),
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
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
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
                // _addAddressBloc.add(AddAddressDataEvent(data: _data));
              },
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
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
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Landline No',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
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
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
            margin: EdgeInsets.symmetric(horizontal: 40),
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
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
              onSaved: (newValue) {
                _data['description'] = newValue!.trim();
              },
            ),
          ),
        ),
        if (_descriptionController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
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

  Column _confirmPasswordInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.lock_outlined,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_confirmPasswordVisible,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_confirmPasswordController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
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

  Column _passwordInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )),
              obscureText: !_passwordVisible,
              onSaved: (newValue) {
                _data['password'] = newValue!.trim();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_passwordController.text == '' && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
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
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
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
            margin: EdgeInsets.symmetric(horizontal: 40),
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

  Column _nameInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.person_outlined,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
              },
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
            margin: EdgeInsets.symmetric(horizontal: 40),
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
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: LocationInput(
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
                child: TextFormField(
                  controller: _addressController,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on), border: InputBorder.none),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _data['address'] = value!.trim();
                  },
                ),
              ),
            ),
            if (_addressController.text == '' && validate)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
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
                    ),            ],
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
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(containerRadius),
                ),
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City', prefixIcon: Icon(Icons.location_on), border: InputBorder.none),
                  readOnly: true,
                  showCursor: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _data['city'] = value!.trim();
                  },
                ),
              ),
            ),
            if (_cityController.text == '' && validate)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
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
                    ),            ],
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
                child: TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(labelText: 'State/Province', prefixIcon: Icon(Icons.location_on), border: InputBorder.none),
                  readOnly: true,
                  showCursor: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _data['state'] = value!.trim();
                  },
                ),
              ),
            ),
            if (_stateController.text == '' && validate)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
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
                    ),            ],
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
                child: TextFormField(
                  controller: _zipCodeController,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'Zip Code', prefixIcon: Icon(Icons.location_on), border: InputBorder.none),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required Field";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _data['pincode'] = value!.trim();
                  },
                ),
              ),
            ),
            if (_zipCodeController.text == '' && validate)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
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
                    ),            ],
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
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'Restaurant Type', prefixIcon: Icon(Icons.restaurant), border: InputBorder.none),
              items: _restaurantTypeList.map((productType) {
                return DropdownMenuItem<String>(
                  value: productType,
                  child: Text(
                    productType,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select Restaurant Type';
                }
                return null;
              },
              onSaved: (newValue) {
                _data['restaurant_type'] = newValue!.trim();
              },
              onChanged: (String? value) {
                setState(() {
                  isRestaurantSelected = true;

                });
                _data['restaurant_type'] = value!.trim();
              },
            ),
          ),
        ),
        if (!isRestaurantSelected && validate)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
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

  Column _buildBusinessLogoWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
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
                        }
                      });
                    }
                  },
                  icon: Icon(
                    Icons.change_circle_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              if (_businessLogo != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _businessLogo = null;
                    });
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _businessLogo == null
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Container(
                      decoration: DottedDecoration(shape: Shape.circle),
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
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: Colors.black),),
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
                    Text('Business Logo'),
                    if (_businessLogo == null && validate)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
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
                            ),            ],
                        ),
                      )
                  ],
                ),
              )
            : Container(
                decoration: DottedDecoration(shape: Shape.circle),
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 170,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: Colors.black)),
                  child: _businessLogo is PickedFile
                      ? Image.network(
                          (_businessLogo as PickedFile).path,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          _businessLogo as Uint8List,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
      ],
    );
  }

  Column _buildCoverPhotoWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
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
                        }
                      });
                    }
                  },
                  icon: Icon(
                    Icons.change_circle_outlined,
                    color: Theme.of(context).primaryColor,
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
                    Icons.delete_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _coverPhoto == null
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                    if (imageFile != null) {
                      Uint8List imageData = await imageFile.readAsBytes();
                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                        if (value != null) {
                          setState(() {
                            _coverPhoto = value as dynamic;
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: DottedDecoration(
                            shape: Shape.circle,
                          ),
                          child: Icon(
                            FeatherIcons.camera,
                            size: 40,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Cover Photo',
                        ),
                        if (_coverPhoto == null && validate)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
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
                                ),            ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                height: 400,
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
            'Photo Gallery',
            style: TextStyle(color: Colors.black),
          ),
          icon: Icon(
            Icons.add_a_photo,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ListView.separated(
          itemCount: _photoGalleyList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                color: Colors.grey.shade200,
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
                              child: _photoGalleyList[index] is PickedFile
                                  ? Image.network(
                                      (_photoGalleyList[index] as PickedFile).path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      _photoGalleyList[index] as Uint8List,
                                      fit: BoxFit.cover,
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
                          Text(
                            'View Image',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
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

  // void showCameraGalleryDialog(String type) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, innerSetState) {
  //           return AlertDialog(
  //             title: Text('Choose Your Option'),
  //             content: Container(
  //               child: Wrap(
  //                 alignment: WrapAlignment.center,
  //                 spacing: 10,
  //                 children: [
  //                   InkWell(
  //                     onTap: () async {
  //                       PickedFile? imageFile = await _getImageFromGallery(ImageSource.camera);
  //                       if (imageFile != null) {
  //                         Uint8List imageData = await imageFile.readAsBytes();
  //                         Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
  //                           if (value != null) {
  //                             imageFile = value as dynamic;
  //                             setState(() {});
  //                           }
  //                         });
  //                       }
  //                       Navigator.of(context).pop(imageFile);
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16),
  //                       child: Column(
  //                         children: [
  //                           Icon(
  //                             Icons.add_a_photo,
  //                             color: Theme.of(context).primaryColor,
  //                             size: 30,
  //                           ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             'Camera',
  //                             style: TextStyle(
  //                               fontSize: 20,
  //                               color: Theme.of(context).primaryColor,
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   InkWell(
  //                     onTap: () async {
  //
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16),
  //                       child: Column(
  //                         children: [
  //                           Icon(
  //                             Icons.image,
  //                             color: Theme.of(context).primaryColor,
  //                             size: 30,
  //                           ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             'Gallery',
  //                             style: TextStyle(
  //                               fontSize: 20,
  //                               color: Theme.of(context).primaryColor,
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null) {
  //       if (type == 'coverphoto') {
  //         _coverPhoto = value as dynamic;
  //       } else if (type == 'businesslogo') {}
  //     }
  //     setState(() {});
  //   });
  // }

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
        _passwordController.text != '' &&
        _confirmPasswordController.text != '' &&
        _descriptionController.text != '' &&
        _mobileNoController.text != '' &&
        _addressController.text != '' &&
        _cityController.text != '' &&
        _stateController.text != '' &&
        _zipCodeController.text != '' &&
        _currentLocation != null &&
        _coverPhoto != null &&
        _businessLogo != null;
  }
}
