import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
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
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:food_hunt_admin_app/widgets/restaurant/local_choosable_main_ingredients_widget.dart';
import 'package:food_hunt_admin_app/widgets/restaurant/local_extra_main_ingredients_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../crop_image_web_screen.dart';
import '../../responsive_layout.dart';

class AddFoodItemScreen extends StatefulWidget {
  AddFoodItemScreen({Key? key}) : super(key: key);

  static const routeName = "/add-food-item";

  @override
  _AddFoodItemScreenState createState() => _AddFoodItemScreenState();
}

class _AddFoodItemScreenState extends State<AddFoodItemScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddFoodItemBloc _addFoodItemBloc = AddFoodItemBloc();
  final GetFoodCategoryBloc _getFoodCategoryBloc = GetFoodCategoryBloc();
  bool validate = false;

  List<FoodCategory> _foodCategoryList = [];

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
    'restaurant_id': 0,
    'food_category_id': 0,
    'name': '',
    'food_type': '',
    'price': 0.0,
    'description': '',
    'food_image': '',
    'type': '',
    'choosable_ingredients': [],
    'extra_ingredients': [],
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

  List _colors = [
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.amber,
    Colors.pink,
    Colors.green,
    Colors.blue,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _nameController.addListener(() {
        setState(() {});
      });
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _getFoodCategoryBloc.add(GetFoodCategoryDataEvent(data: {
        'restaurant_id': restaurant!.emailId,
      }));
      _localChoosableMainIngredientsList.add(
        LocalChoosableMainIngredients(
          name: '',
          color: _colors[Random().nextInt(_colors.length)],
          subCategoryList: [
            LocalChoosableSubIngredients(
              name: '',
              color: _colors[Random().nextInt(_colors.length)],
            ),
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
      bloc: _addFoodItemBloc,
      listener: (context, state) {
        if (state is AddFoodItemSuccessState) {
          Navigator.of(context).pop(state.foodItem);
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
              margin: EdgeInsets.only(left: 20),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choosable Ingredients',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 22,
                          fontColor: Colors.black,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _localChoosableMainIngredientsList.add(
                              LocalChoosableMainIngredients(
                                name: '',
                                color: _colors[Random().nextInt(_colors.length)],
                                subCategoryList: [
                                  LocalChoosableSubIngredients(
                                    name: '',
                                    color: _colors[Random().nextInt(_colors.length)],
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text(
                          'Add more',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return LocalChoosableMainIngredientsWidget(
                        index: index,
                        localChoosableMainIngredients: _localChoosableMainIngredientsList[index],
                        updateTextCallBack: (value) {
                          _localChoosableMainIngredientsList[index].name = value;
                        },
                        updateListCallBack: (tempLocalChoosableMainIngredients, index) {
                          _localChoosableMainIngredientsList.removeAt(index);
                          _localChoosableMainIngredientsList.insert(index, tempLocalChoosableMainIngredients);
                        },
                        addSubCallBack: (index) {
                          var mainIngredients = _localChoosableMainIngredientsList.removeAt(index);
                          setState(() {
                            _localChoosableMainIngredientsList.insert(
                              index,
                              LocalChoosableMainIngredients(
                                name: mainIngredients.name,
                                color: mainIngredients.color,
                                subCategoryList: mainIngredients.subCategoryList
                                  ..add(
                                    LocalChoosableSubIngredients(
                                      name: '',
                                      color: _colors[Random().nextInt(_colors.length)],
                                    ),
                                  ),
                              ),
                            );
                          });
                        },
                        deleteCallBack: (index) {
                          setState(() {
                            _localChoosableMainIngredientsList.removeAt(index);
                          });
                        },
                        deleteSubCallBack: (mainIndex, subIndex) {
                          setState(() {
                            _localChoosableMainIngredientsList[mainIndex].subCategoryList.removeAt(subIndex);
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: _localChoosableMainIngredientsList.length,
                  ),
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
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Extra for ${_nameController.text}',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 22,
                          fontColor: Colors.black,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _localExtraMainIngredientsList.add(
                              LocalExtraMainIngredients(
                                name: '',
                                color: _colors[Random().nextInt(_colors.length)],
                                subCategoryList: [
                                  LocalExtraSubIngredients(
                                    name: '',
                                    color: _colors[Random().nextInt(_colors.length)],
                                    price: 0.0,
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text(
                          'Add more',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return LocalExtraMainIngredientsWidget(
                        index: index,
                        localExtraMainIngredients: _localExtraMainIngredientsList[index],
                        updateTextCallBack: (value) {
                          _localExtraMainIngredientsList[index].name = value;
                        },
                        updateListCallBack: (tempLocalExtraMainIngredients, index) {
                          _localExtraMainIngredientsList.removeAt(index);
                          _localExtraMainIngredientsList.insert(index, tempLocalExtraMainIngredients);
                        },
                        addSubCallBack: (index) {
                          var mainIngredients = _localExtraMainIngredientsList.removeAt(index);
                          setState(() {
                            _localExtraMainIngredientsList.insert(
                              index,
                              LocalExtraMainIngredients(
                                name: mainIngredients.name,
                                color: mainIngredients.color,
                                subCategoryList: mainIngredients.subCategoryList
                                  ..add(
                                    LocalExtraSubIngredients(
                                      name: '',
                                      color: _colors[Random().nextInt(_colors.length)],
                                      price: 0.0,
                                    ),
                                  ),
                              ),
                            );
                          });
                        },
                        deleteCallBack: (index) {
                          setState(() {
                            _localExtraMainIngredientsList.removeAt(index);
                          });
                        },
                        deleteSubCallBack: (mainIndex, subIndex) {
                          setState(() {
                            _localExtraMainIngredientsList[mainIndex].subCategoryList.removeAt(subIndex);
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: _localExtraMainIngredientsList.length,
                  ),
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
                _data['choosable_ingredients'] = _localChoosableMainIngredientsList.map((e) {
                  return LocalChoosableMainIngredients.toJson(e);
                }).toList();
                _data['extra_ingredients'] = _localExtraMainIngredientsList.map((e) {
                  return LocalExtraMainIngredients.toJson(e);
                }).toList();
                _data['food_image'] = _foodImage is PickedFile ? base64Encode(await _foodImage.readAsBytes()) : base64Encode(_foodImage as Uint8List);
                _formKey.currentState!.save();
                _addFoodItemBloc.add(
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
            color: _data['type'] == '' && validate ? Colors.red : Colors.grey.shade800,
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
              items: _typeList.map((type) {
                return DropdownMenuItem<Map<String, String>>(
                  value: type,
                  child: Text(
                    type['title'] ?? '',
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
          _foodCategoryList = state.foodCategoryList;
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
                color: _data['food_category_id'] == 0 && validate ? Colors.red : Colors.grey.shade800,
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
                  items: _foodCategoryList.map((foodCategory) {
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
                    _data['food_category_id'] = newValue!.id;
                  },
                  onChanged: (value) {
                    _data['food_category_id'] = value!.id;
                  },
                ),
              ),
            ),
            if (_data['food_category_id'] == 0 && validate)
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
              items: _foodTypeList.map((foodType) {
                return DropdownMenuItem<Map<String, String>>(
                  value: foodType,
                  child: Text(
                    foodType['title'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onSaved: (newValue) {
                _data['food_type'] = newValue!['value'];
              },
              onChanged: (value) {
                _data['food_type'] = value!['value'];
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
    return _nameController.text != '' &&
        _data['food_category_id'] != '' &&
        _data['food_type'] != '' &&
        _data['type'] != '' &&
        _priceController.text != '' &&
        _descriptionController.text != '' &&
        _foodImage != null;
  }
}
