import 'dart:typed_data';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_category/get_food_category/get_food_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_item/add_food_item/add_food_item_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/models/local_choosable_main_ingredients.dart';
import 'package:food_hunt_admin_app/models/local_choosable_sub_ingredients.dart';
import 'package:food_hunt_admin_app/models/local_extra_main_ingredients.dart';
import 'package:food_hunt_admin_app/models/local_extra_sub_ingredients.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/utils/validators.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../crop_image_web_screen.dart';
import '../../responsive_layout.dart';

class AddFoodItemScreen extends StatefulWidget {
  const AddFoodItemScreen({Key? key}) : super(key: key);

  static const routeName = "/add-food-item";

  @override
  _AddFoodItemScreenState createState() => _AddFoodItemScreenState();
}

class _AddFoodItemScreenState extends State<AddFoodItemScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddFoodItemBloc _addRestaurantBloc = AddFoodItemBloc();
  final GetFoodCategoryBloc _getFoodCategoryBloc = GetFoodCategoryBloc();
  bool validate = false;

  List<FoodCategory> _foodCategory = [];

  List<Map<String, String>> _typeList = [
    {
      'title': 'Normal',
      'value': 'normal',
    },
    {
      'title': 'Create Your Own',
      'value': 'custom',
    }
  ];

  List<Map<String, String>> _foodTypeList = [
    {
      'title': 'Vegetarian',
      'value': 'veg',
    },
    {
      'title': 'Non-Vegetarian',
      'value': 'non_veg',
    }
  ];

  Map<String, dynamic> _data = {
    'restaurant_id': '',
    'food_category_id': '',
    'name': '',
    'food_type': '',
    'price': '',
    'description': '',
    'image': '',
    'type': '',
  };

  final picker = ImagePicker();
  dynamic _foodImage;

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
  var _descriptionController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  Restaurant? restaurant;

  List<LocalChoosableMainIngredients> _localChoosableMainIngredientsList = [];
  List<LocalExtraMainIngredients> _localExtraMainIngredientsList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _getFoodCategoryBloc.add(GetFoodCategoryDataEvent(data: {
        'restaurant_id': restaurant!.emailId,
      }));
      _localChoosableMainIngredientsList.add(
        LocalChoosableMainIngredients(
          name: '',
          subCategoryList: [
            LocalChoosableSubIngredients(name: ''),
          ],
        ),
      );
      _localExtraMainIngredientsList.add(
        LocalExtraMainIngredients(
          name: '',
          subCategoryList: [
            LocalExtraSubIngredients(
              name: '',
              price: 0.0,
            ),
          ],
        ),
      );
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFoodItemBloc, AddFoodItemState>(
      bloc: _addRestaurantBloc,
      listener: (context, state) {
        if (state is AddFoodItemSuccessState) {
          Navigator.of(context).pop(state.foodCategory);
        } else if (state is AddFoodItemFailureState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is AddFoodItemExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: state is AddFoodItemLoadingState
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
                'Add Food Item',
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
                _buildFoodImageWidget(),
                SizedBox(
                  height: 20,
                ),
                _nameInputWidget(),
                SizedBox(
                  height: 10,
                ),
                _foodCategoryDropDownWidget(),
                SizedBox(
                  height: 10,
                ),
                _foodTypeDropDownWidget(),
                SizedBox(
                  height: 10,
                ),
                _typeDropDownWidget(),
                SizedBox(
                  height: 10,
                ),
                _priceInputWidget(),
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
                Text(
                  'Chooseable Ingredients',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 22, fontColor: Colors.black),
                ),
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
                _formKey.currentState!.save();
                _addRestaurantBloc.add(
                  AddFoodItemAddEvent(addFoodItemData: _data),
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
              },
              onSaved: (newValue) {
                _data['email_id'] = newValue!.trim();
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
                hintText: 'Food Name',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.fastfood,
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

  Column _typeDropDownWidget() {
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
                hintText: 'Type',
                prefixIcon: Icon(Icons.food_bank),
                border: InputBorder.none,
              ),
              items: _typeList.map((productType) {
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
                _data['type'] = newValue!['value']!.trim();
              },
              onChanged: (value) {
                _data['type'] = value!['value']!.trim();
              },
            ),
          ),
        ),
        if (_data['type'] == '' && validate)
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

  Widget _foodCategoryDropDownWidget() {
    return BlocConsumer<GetFoodCategoryBloc, GetFoodCategoryState>(
      bloc: _getFoodCategoryBloc,
      listener: (context, state) {
        if (state is GetFoodCategorySuccessState) {
          _foodCategory = state.foodCategoryList;
        } else if (state is GetFoodCategoryFailedState) {
          _showSnackMessage(state.message, Colors.red.shade600);
        } else if (state is GetFoodCategoryExceptionState) {
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
                child: DropdownButtonFormField<FoodCategory>(
                  decoration: InputDecoration(
                    hintText: 'Food Category',
                    prefixIcon: Icon(Icons.restaurant_menu),
                    border: InputBorder.none,
                  ),
                  items: _foodCategory.map((foodCategory) {
                    return DropdownMenuItem<FoodCategory>(
                      value: foodCategory,
                      child: Text(
                        foodCategory.name,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onSaved: (newValue) {
                    _data['restaurant_type'] = newValue;
                  },
                  onChanged: (value) {
                    _data['restaurant_type'] = value;
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
      },
    );
  }

  Column _foodTypeDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: _data['food_type'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
                hintText: 'Food Type',
                prefixIcon: Icon(Icons.restaurant),
                border: InputBorder.none,
              ),
              items: _foodTypeList.map((productType) {
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
                _data['food_type'] = newValue!['value']!.trim();
              },
              onChanged: (value) {
                _data['food_type'] = value!['value']!.trim();
              },
            ),
          ),
        ),
        if (_data['food_type'] == '' && validate)
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

  Widget _buildFoodImageWidget() {
    return _foodImage == null
        ? Column(
            children: [
              Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(20),
                  color: _foodImage == null && validate ? Colors.red : Colors.grey.shade800,
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
                            _foodImage = value as dynamic;
                          });
                        } else {
                          setState(() {
                            _foodImage = imageFile;
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
              Text('FOOD IMAGE'),
              if (_foodImage == null && validate)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin * 2),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        'Please select your food image !!',
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
                  if (_foodImage != null)
                    IconButton(
                      onPressed: () async {
                        PickedFile? imageFile = await _getImageFromGallery(ImageSource.gallery);
                        if (imageFile != null) {
                          Uint8List imageData = await imageFile.readAsBytes();
                          Navigator.of(context).pushNamed(CropImageWebScreen.routeName, arguments: imageData).then((value) {
                            if (value != null) {
                              setState(() {
                                _foodImage = value as dynamic;
                              });
                            } else {
                              setState(() {
                                _foodImage = imageFile;
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
                  Text('FOOD IMAGE'),
                  SizedBox(width: 20),
                  if (_foodImage != null)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _foodImage = null;
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
                  child: _foodImage is PickedFile
                      ? Image.network(
                          (_foodImage as PickedFile).path,
                          height: 170,
                          width: 170,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          _foodImage as Uint8List,
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
    return _nameController.text != '' && _data['restaurant_type'] != '' && _priceController.text != '' && _foodImage != null && Validators.isValidEmail(_priceController.text);
  }
}
