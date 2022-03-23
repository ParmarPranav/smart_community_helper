import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/liquor_category/get_liquor_category/get_liquor_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/liquor_item/add_liquor_item/add_liquor_item_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_category.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../crop_image_web_screen.dart';
import '../../responsive_layout.dart';

class AddLiquorItemScreen extends StatefulWidget {
  const AddLiquorItemScreen({Key? key}) : super(key: key);

  static const routeName = "/add-liquor-item";

  @override
  _AddLiquorItemScreenState createState() => _AddLiquorItemScreenState();
}

class _AddLiquorItemScreenState extends State<AddLiquorItemScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddLiquorItemBloc _addLiquorItemBloc = AddLiquorItemBloc();
  final GetLiquorCategoryBloc _getLiquorCategoryBloc = GetLiquorCategoryBloc();
  bool validate = false;

  List<LiquorCategory> _liquorCategoryList = [];

  Map<String, dynamic> _data = {
    'restaurant_id': '',
    'liquor_category_id': 0,
    'name': '',
    'price': 0.0,
    'original_price': 0.0,
    'description': '',
    'liquor_image': '',
  };

  final picker = ImagePicker();
  dynamic _liquorImage;

  Future<PickedFile?> _getImageFromGallery(ImageSource imageSource) async {
    PickedFile? pickedFile = await picker.getImage(
      source: imageSource,
    );
    if (pickedFile != null) {
      return pickedFile;
    }
    return null;
  }

  var _nameController = TextEditingController();
  var _priceController = TextEditingController();
  var _originalPriceController = TextEditingController();
  var _descriptionController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  Restaurant? restaurant;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _getLiquorCategoryBloc.add(GetLiquorCategoryDataEvent(data: {
        'restaurant_id': restaurant!.emailId,
      }));

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddLiquorItemBloc, AddLiquorItemState>(
      bloc: _addLiquorItemBloc,
      listener: (context, state) {
        if (state is AddLiquorItemSuccessState) {
          Navigator.of(context).pop(state.liquorItem);
        } else if (state is AddLiquorItemFailureState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is AddLiquorItemExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: state is AddLiquorItemLoadingState
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
                'Add Liquor Item',
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
                _buildLiquorImageWidget(),
                SizedBox(
                  height: 20,
                ),
                _nameInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _liquorCategoryDropDownWidget(),
                SizedBox(
                  height: 10,
                ),
                _priceInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _originalPriceInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _descriptionInputWidget(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
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
                _data['restaurant_id'] = restaurant!.emailId;
                _data['liquor_image'] = _liquorImage is PickedFile ? base64Encode(await _liquorImage.readAsBytes()) : base64Encode(_liquorImage as Uint8List);
                _formKey.currentState!.save();
                _addLiquorItemBloc.add(
                  AddLiquorItemAddEvent(addLiquorItemData: _data),
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
                return null;
              },
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

  Column _priceInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _priceController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _priceController,
              decoration: InputDecoration(
                hintText: 'Price',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
                return null;
              },
              onSaved: (newValue) {
                _data['price'] = newValue != null ? num.parse(newValue.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_priceController.text == '' && validate)
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

  Column _originalPriceInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _originalPriceController.text == '' && validate ? Colors.red : Colors.grey.shade800,
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
              controller: _originalPriceController,
              decoration: InputDecoration(
                hintText: 'Original Price',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
                return null;
              },
              onSaved: (newValue) {
                _data['original_price'] = newValue != null ? num.parse(newValue.trim()).toDouble() : 0.0;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        if (_originalPriceController.text == '' && validate)
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
                hintText: 'Liquor Name',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.fastfood,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
                return null;
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

  Widget _liquorCategoryDropDownWidget() {
    return BlocConsumer<GetLiquorCategoryBloc, GetLiquorCategoryState>(
      bloc: _getLiquorCategoryBloc,
      listener: (context, state) {
        if (state is GetLiquorCategorySuccessState) {
          _liquorCategoryList = state.liquorCategoryList;
        } else if (state is GetLiquorCategoryFailedState) {
          _showSnackMessage(state.message, Colors.red.shade600);
        } else if (state is GetLiquorCategoryExceptionState) {
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
                color: _data['liquor_category_id'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
                child: DropdownButtonFormField<LiquorCategory>(
                  decoration: InputDecoration(
                    hintText: 'Liquor Category',
                    prefixIcon: Icon(Icons.restaurant_menu),
                    border: InputBorder.none,
                  ),
                  items: _liquorCategoryList.map((liquorCategory) {
                    return DropdownMenuItem<LiquorCategory>(
                      value: liquorCategory,
                      child: Text(
                        liquorCategory.name,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onSaved: (newValue) {
                    _data['liquor_category_id'] = newValue!.id;
                  },
                  onChanged: (value) {
                    _data['liquor_category_id'] = value!.id;
                  },
                ),
              ),
            ),
            if (_data['liquor_category_id'] == '' && validate)
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

  Widget _buildLiquorImageWidget() {
    return _liquorImage == null
        ? Column(
            children: [
              Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(20),
                  color: _liquorImage == null && validate ? Colors.red : Colors.grey.shade800,
                ),
                padding: EdgeInsets.all(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                    if (imageFile != null) {
                      Uint8List imageData = await imageFile.readAsBytes();
                      Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                        if (value != null) {
                          setState(() {
                            _liquorImage = value as dynamic;
                          });
                        } else {
                          setState(() {
                            _liquorImage = imageFile;
                          });
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
              Text('LIQUOR IMAGE'),
              if (_liquorImage == null && validate)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        'Please select your liquor image !!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_liquorImage != null)
                    IconButton(
                      onPressed: () async {
                        PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                        if (imageFile != null) {
                          Uint8List imageData = await imageFile.readAsBytes();
                          Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                            if (value != null) {
                              setState(() {
                                _liquorImage = value as dynamic;
                              });
                            } else {
                              setState(() {
                                _liquorImage = imageFile;
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
                  Text('LIQUOR IMAGE'),
                  SizedBox(width: 20),
                  if (_liquorImage != null)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _liquorImage = null;
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
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _liquorImage is PickedFile
                      ? Image.network(
                          (_liquorImage as PickedFile).path,
                          height: 170,
                          width: 170,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          _liquorImage as Uint8List,
                          height: 170,
                          width: 170,
                          fit: BoxFit.cover,
                        ),
                ),
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
    return _nameController.text != '' && _data['liquor_category_id'] != '' && _priceController.text != '' && _liquorImage != null && _descriptionController.text != '';
  }
}
