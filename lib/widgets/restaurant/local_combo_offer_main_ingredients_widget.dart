import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

import '../../models/local_combo_offer_main_ingredients.dart';
import 'local_combo_offer_sub_ingredients_widget.dart';

class LocalComboOfferMainIngredientsWidget extends StatefulWidget {
  final int index;
  final LocalComboOfferMainIngredients localComboOfferMainIngredients;
  final Function updateTextCallBack;
  final Function updateListCallBack;
  final Function addSubCallBack;
  final Function deleteCallBack;
  final Function deleteSubCallBack;

  LocalComboOfferMainIngredientsWidget({
    required this.index,
    required this.localComboOfferMainIngredients,
    required this.updateTextCallBack,
    required this.updateListCallBack,
    required this.addSubCallBack,
    required this.deleteCallBack,
    required this.deleteSubCallBack,
  });

  @override
  _LocalComboOfferMainIngredientsWidgetState createState() => _LocalComboOfferMainIngredientsWidgetState();
}

class _LocalComboOfferMainIngredientsWidgetState extends State<LocalComboOfferMainIngredientsWidget> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.localComboOfferMainIngredients.name;
    _textEditingController.addListener(() {
      widget.updateTextCallBack(_textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.localComboOfferMainIngredients.color,
              radius: 15,
              child: Text(
                '${widget.index + 1}',
                style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                  fontSize: 14,
                  fontColor: Colors.white,
                ),
              ),
            ),
            title: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter a ingredient name',
                  hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                    fontSize: 16,
                    fontColor: Colors.grey,
                  ),
                  border: InputBorder.none),
              style: ProjectConstant.WorkSansFontRegularTextStyle(
                fontSize: 16,
                fontColor: Colors.black,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _showDeleteConfirmation();
              },
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
        if (widget.localComboOfferMainIngredients.subCategoryList.length > 0)
          Container(
            margin: EdgeInsets.only(left: 70, top: 8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LocalComboOfferSubIngredientsWidget(
                  index: index,
                  localComboOfferSubIngredients: widget.localComboOfferMainIngredients.subCategoryList[index],
                  updateNameCallBack: (value) {
                    widget.localComboOfferMainIngredients.subCategoryList[index].name = value;
                    widget.updateListCallBack(widget.localComboOfferMainIngredients, widget.index);
                  },
                  updatePriceCallBack: (value) {
                    widget.localComboOfferMainIngredients.subCategoryList[index].price = value != '' ? num.parse(value).toDouble() : 0.0;
                    widget.updateListCallBack(widget.localComboOfferMainIngredients, widget.index);
                  },
                  updateOriginalPriceCallBack: (value) {
                    widget.localComboOfferMainIngredients.subCategoryList[index].originalPrice = value != '' ? num.parse(value).toDouble() : 0.0;
                    widget.updateListCallBack(widget.localComboOfferMainIngredients, widget.index);
                  },
                  updateIsFreeCallBack: (value) {
                    widget.localComboOfferMainIngredients.subCategoryList[index].isFree = value;
                    if (value == '1') {
                      widget.localComboOfferMainIngredients.subCategoryList[index].price = 0.0;
                      widget.localComboOfferMainIngredients.subCategoryList[index].originalPrice = 0.0;
                    }
                    widget.updateListCallBack(widget.localComboOfferMainIngredients, widget.index);
                  },
                  addCallBack: () {
                    widget.addSubCallBack(widget.index);
                  },
                  deleteCallBack: (index) {
                    widget.deleteSubCallBack(widget.index, index);
                  },
                  subCategoryList: widget.localComboOfferMainIngredients.subCategoryList,
                );
              },
              itemCount: widget.localComboOfferMainIngredients.subCategoryList.length,
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
