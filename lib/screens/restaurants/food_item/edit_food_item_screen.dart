import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_category/get_food_category/get_food_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_item/edit_food_item/edit_food_item_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/models/local_choosable_main_ingredients.dart';
import 'package:food_hunt_admin_app/models/local_choosable_sub_ingredients.dart';
import 'package:food_hunt_admin_app/models/local_extra_main_ingredients.dart';
import 'package:food_hunt_admin_app/models/local_extra_sub_ingredients.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';
import 'package:food_hunt_admin_app/widgets/restaurant/local_choosable_main_ingredients_widget.dart';
import 'package:food_hunt_admin_app/widgets/restaurant/local_extra_main_ingredients_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../crop_image_web_screen.dart';
import '../../responsive_layout.dart';

class EditFoodItemScreen extends StatefulWidget {
  EditFoodItemScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-food-item";

  @override
  _EditFoodItemScreenState createState() => _EditFoodItemScreenState();
}

class _EditFoodItemScreenState extends State<EditFoodItemScreen> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditFoodItemBloc _editFoodItemBloc = EditFoodItemBloc();
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
    'id': 0,
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

  FoodItem? foodItem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      foodItem = ModalRoute.of(context)!.settings.arguments as FoodItem?;
      _getFoodCategoryBloc.add(GetFoodCategoryDataEvent(data: {
        'restaurant_id': foodItem!.restaurantId,
      }));
      _localChoosableMainIngredientsList = foodItem!.choosableIngredientsMainCategoryList.map((main) {
        return LocalChoosableMainIngredients(
          name: main.name,
          color: _colors[Random().nextInt(_colors.length)],
          subCategoryList: main.choosableIngredientsSubCategoryList
              .map((sub) => LocalChoosableSubIngredients(
                    name: sub.name,
                    color: _colors[Random().nextInt(_colors.length)],
                  ))
              .toList(),
        );
      }).toList();
      _localExtraMainIngredientsList = foodItem!.extraIngredientsMainCategoryList.map((main) {
        return LocalExtraMainIngredients(
          name: main.name,
          color: _colors[Random().nextInt(_colors.length)],
          subCategoryList: main.extraIngredientsSubCategoryList
              .map((sub) => LocalExtraSubIngredients(
                    name: sub.name,
                    price: sub.price,
                    color: _colors[Random().nextInt(_colors.length)],
                  ))
              .toList(),
        );
      }).toList();
      _data = {
        'id': foodItem!.id,
        'food_category_id': foodItem!.foodCategoryId,
        'name': foodItem!.name,
        'food_type': foodItem!.foodType,
        'price': foodItem!.price,
        'description': foodItem!.description,
        'old_food_image': foodItem!.image,
        'type': foodItem!.type,
        'choosable_ingredients': [],
        'extra_ingredients': [],
      };
      _nameController.text = foodItem!.name;
      _priceController.text = foodItem!.price.toStringAsFixed(2);
      _descriptionController.text = foodItem!.description;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditFoodItemBloc, EditFoodItemState>(
      bloc: _editFoodItemBloc,
      listener: (context, state) {
        if (state is EditFoodItemSuccessState) {
          Navigator.of(context).pop(state.foodItem);
        } else if (state is EditFoodItemFailureState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is EditFoodItemExceptionState) {
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: state is EditFoodItemLoadingState
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
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Edit Food Item',
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
                        'Removeable Ingredients',
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
                        'Extra Ingredients${_nameController.text == ' for ${_nameController.text}' ? _nameController.text : ''}',
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
              onPressed: _save,
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
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _save() async {
    setState(() {
      validate = true;
    });
    if (!isFormValid()) {
      return;
    }
    if (_localChoosableMainIngredientsList.length > 0) {
      for (int iIndex = 0; iIndex < _localChoosableMainIngredientsList.length; iIndex++) {
        var element = _localChoosableMainIngredientsList[iIndex];
        if (element.name == '' || element.subCategoryList.length == 0) {
          _showSnackMessage('Please enter choosable ingredients', Colors.red.shade700);
          return;
        }
        for (int jIndex = 0; jIndex < element.subCategoryList.length; jIndex++) {
          var subElement = element.subCategoryList[jIndex];
          if (subElement.name == '') {
            _showSnackMessage('Please enter choosable sub-ingredients', Colors.red.shade700);
            return;
          }
        }
      }
    }

    if (_localExtraMainIngredientsList.length > 0) {
      for (int iIndex = 0; iIndex < _localExtraMainIngredientsList.length; iIndex++) {
        var element = _localExtraMainIngredientsList[iIndex];
        if (element.name == '' || element.subCategoryList.length == 0) {
          _showSnackMessage('Please enter extra ingredients', Colors.red.shade700);
          return;
        }
        for (int jIndex = 0; jIndex < element.subCategoryList.length; jIndex++) {
          var subElement = element.subCategoryList[jIndex];
          if (subElement.name == '' || subElement.price == 0.0) {
            _showSnackMessage('Please enter extra sub-ingredients', Colors.red.shade700);
            return;
          }
        }
      }
    }
    _data['id'] = foodItem!.id;
    _data['choosable_ingredients'] = _localChoosableMainIngredientsList.map((e) {
      return LocalChoosableMainIngredients.toJson(e);
    }).toList();
    _data['extra_ingredients'] = _localExtraMainIngredientsList.map((e) {
      return LocalExtraMainIngredients.toJson(e);
    }).toList();
    if (_foodImage != null) {
      _data['food_image'] = _foodImage is PickedFile ? base64Encode(await _foodImage.readAsBytes()) : base64Encode(_foodImage as Uint8List);
    }
    _formKey.currentState!.save();
    _editFoodItemBloc.add(
      EditFoodItemAddEvent(
        editFoodItemData: _data,
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
              value: _typeList.firstWhere((element) => element['value'] == _data['type']),
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
        return state is GetFoodCategoryLoadingState || state is GetFoodCategoryInitialState
            ? Container()
            : Column(
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
                        value: _foodCategoryList.firstWhere((element) => element.id == _data['food_category_id']),
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
              value: _foodTypeList.firstWhere((element) => element['value'] == _data['food_type']),
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
    if (_data['old_food_image'] != '' && _foodImage == null) {
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
              IconButton(
                onPressed: () {
                  setState(() {
                    _data['old_food_image'] = '';
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
              child: CachedNetworkImage(
                imageUrl: './${_data['old_food_image']}',
                height: 170,
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    } else if (_data['old_food_image'] == '' && _foodImage == null) {
      return Column(
        children: [
          Container(
            decoration: DottedDecoration(
              shape: Shape.box,
              borderRadius: BorderRadius.circular(20),
              color: (_data['old_food_image'] != '' || _foodImage != null) && validate ? Colors.red : Colors.grey.shade800,
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
          Text('FOOD IMAGE',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
            fontSize: 16,
            fontColor: Colors.black,
          ),),
          if ((_data['old_food_image'] != '' || _foodImage != null) && validate)
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
      );
    } else {
      return Column(
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
              Text('FOOD IMAGE',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                fontSize: 16,
                fontColor: Colors.black,
              ),),
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
        (_data['old_food_image'] != '' || _foodImage != null);
  }
}
