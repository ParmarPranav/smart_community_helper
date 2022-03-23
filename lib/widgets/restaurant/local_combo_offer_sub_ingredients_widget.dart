import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

import '../../models/local_combo_offer_sub_ingredients.dart';

class LocalComboOfferSubIngredientsWidget extends StatefulWidget {
  final int index;
  final LocalComboOfferSubIngredients localComboOfferSubIngredients;
  final Function updateNameCallBack;
  final Function updatePriceCallBack;
  final Function updateOriginalPriceCallBack;
  final Function updateIsFreeCallBack;
  final Function addCallBack;
  final Function deleteCallBack;
  final List<LocalComboOfferSubIngredients> subCategoryList;

  LocalComboOfferSubIngredientsWidget({
    required this.index,
    required this.localComboOfferSubIngredients,
    required this.updateNameCallBack,
    required this.updatePriceCallBack,
    required this.updateOriginalPriceCallBack,
    required this.updateIsFreeCallBack,
    required this.addCallBack,
    required this.deleteCallBack,
    required this.subCategoryList,
  });

  @override
  _LocalComboOfferSubIngredientsWidgetState createState() => _LocalComboOfferSubIngredientsWidgetState();
}

class _LocalComboOfferSubIngredientsWidgetState extends State<LocalComboOfferSubIngredientsWidget> {
  final _nameTextEditingController = TextEditingController();
  final _priceTextEditingController = TextEditingController();
  final _originalPriceTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTextEditingController.text = widget.localComboOfferSubIngredients.name;
    _priceTextEditingController.text = widget.localComboOfferSubIngredients.price.toStringAsFixed(2);
    _originalPriceTextEditingController.text = widget.localComboOfferSubIngredients.originalPrice.toStringAsFixed(2);
    _nameTextEditingController.addListener(() {
      widget.updateNameCallBack(_nameTextEditingController.text);
    });
    _priceTextEditingController.addListener(() {
      widget.updatePriceCallBack(_priceTextEditingController.text);
    });
    _originalPriceTextEditingController.addListener(() {
      widget.updateOriginalPriceCallBack(_originalPriceTextEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        InkWell(
          onTap: widget.index == 0
              ? () {
                  widget.addCallBack();
                }
              : null,
          child: Icon(
            Icons.add_circle,
            size: 32,
            color: widget.index == 0 ? Colors.red.shade700 : Colors.transparent,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.localComboOfferSubIngredients.color,
                        radius: 15,
                        child: Text(
                          '${widget.index + 1}',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 14,
                            fontColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _nameTextEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter a sub-ingredient name',
                            hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                              fontSize: 14,
                              fontColor: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 14,
                            fontColor: Colors.black,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required Field';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          if (widget.subCategoryList.length > 1) {
                            _showDeleteConfirmation();
                          }
                        },
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      )
                    ],
                  ),
                  if (widget.localComboOfferSubIngredients.isFree == '0')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Divider(),
                        Row(
                          children: [
                            SizedBox(width: 30),
                            Expanded(
                              child: TextFormField(
                                controller: _priceTextEditingController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money),
                                  prefixIconConstraints: BoxConstraints(
                                    maxHeight: 40,
                                    maxWidth: 48,
                                  ),
                                  hintText: 'price',
                                  hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                                    fontSize: 14,
                                    fontColor: Colors.grey,
                                  ),
                                  isDense: false,
                                  border: InputBorder.none,
                                ),
                                style: ProjectConstant.WorkSansFontRegularTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.black,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Required Field';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _originalPriceTextEditingController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money),
                                  prefixIconConstraints: BoxConstraints(
                                    maxHeight: 40,
                                    maxWidth: 48,
                                  ),
                                  hintText: 'original price',
                                  hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                                    fontSize: 14,
                                    fontColor: Colors.grey,
                                  ),
                                  isDense: false,
                                  border: InputBorder.none,
                                ),
                                style: ProjectConstant.WorkSansFontRegularTextStyle(
                                  fontSize: 14,
                                  fontColor: Colors.black,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Required Field';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Checkbox(
                        value: widget.localComboOfferSubIngredients.isFree == '1',
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              widget.localComboOfferSubIngredients.originalPrice = 0.0;
                              _originalPriceTextEditingController.text = '0.0';
                              widget.localComboOfferSubIngredients.price = 0.0;
                              _priceTextEditingController.text = '0.0';
                            }
                            widget.localComboOfferSubIngredients.isFree = value ? '1' : '0';
                          });
                          widget.updateIsFreeCallBack(value! ? '1' : '0');
                        },
                      ),
                      Text(
                        'Free',
                        style: ProjectConstant.WorkSansFontMediumTextStyle(
                          fontSize: 16,
                          fontColor: Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() async {
    var response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete Ingredient'),
          content: Text('Do you really want to delete this ingredient ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    if (response != null) {
      widget.deleteCallBack(widget.index);
    }
  }
}
