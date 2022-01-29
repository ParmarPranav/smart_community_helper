import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/local_extra_sub_ingredients.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

class LocalExtraSubIngredientsWidget extends StatefulWidget {
  final int index;
  final LocalExtraSubIngredients localExtraSubIngredients;
  final Function updateNameCallBack;
  final Function updatePriceCallBack;
  final Function addCallBack;
  final Function deleteCallBack;
  final List<LocalExtraSubIngredients> subCategoryList;

  LocalExtraSubIngredientsWidget({
    required this.index,
    required this.localExtraSubIngredients,
    required this.updateNameCallBack,
    required this.updatePriceCallBack,
    required this.addCallBack,
    required this.deleteCallBack,
    required this.subCategoryList,
  });

  @override
  _LocalExtraSubIngredientsWidgetState createState() => _LocalExtraSubIngredientsWidgetState();
}

class _LocalExtraSubIngredientsWidgetState extends State<LocalExtraSubIngredientsWidget> {
  final _nameTextEditingController = TextEditingController();
  final _priceTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTextEditingController.addListener(() {
      widget.updateNameCallBack(_nameTextEditingController.text);
    });
    _priceTextEditingController.addListener(() {
      widget.updatePriceCallBack(_priceTextEditingController.text);
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
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: widget.localExtraSubIngredients.color,
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
                    child: Row(
                      children: [
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
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _priceTextEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.attach_money),
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 40,
                                maxWidth: 48,
                              ),
                              hintText: 'Enter a sub-ingredient price',
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
                            },
                          ),
                        ),
                      ],
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
