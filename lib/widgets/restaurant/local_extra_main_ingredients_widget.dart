import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/local_extra_main_ingredients.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

import 'local_extra_sub_ingredients_widget.dart';

class LocalExtraMainIngredientsWidget extends StatefulWidget {
  final int index;
  final LocalExtraMainIngredients localExtraMainIngredients;
  final Function updateTextCallBack;
  final Function updateListCallBack;
  final Function addSubCallBack;
  final Function deleteCallBack;
  final Function deleteSubCallBack;

  LocalExtraMainIngredientsWidget({
    required this.index,
    required this.localExtraMainIngredients,
    required this.updateTextCallBack,
    required this.updateListCallBack,
    required this.addSubCallBack,
    required this.deleteCallBack,
    required this.deleteSubCallBack,
  });

  @override
  _LocalExtraMainIngredientsWidgetState createState() => _LocalExtraMainIngredientsWidgetState();
}

class _LocalExtraMainIngredientsWidgetState extends State<LocalExtraMainIngredientsWidget> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.localExtraMainIngredients.name;
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
              backgroundColor: widget.localExtraMainIngredients.color,
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
                  hintText: 'Enter ingredient name',
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
        if (widget.localExtraMainIngredients.subCategoryList.length > 0)
          Container(
            margin: EdgeInsets.only(left: 70, top: 8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LocalExtraSubIngredientsWidget(
                  index: index,
                  localExtraSubIngredients: widget.localExtraMainIngredients.subCategoryList[index],
                  updateNameCallBack: (value) => _updateSubNameCallBack(value, index),
                  updatePriceCallBack: (value) => _updateSubPriceCallBack(value, index),
                  addCallBack: () {
                    widget.addSubCallBack(widget.index);
                  },
                  deleteCallBack: (index) {
                    widget.deleteSubCallBack(widget.index, index);
                  },
                  subCategoryList: widget.localExtraMainIngredients.subCategoryList,
                );
              },
              itemCount: widget.localExtraMainIngredients.subCategoryList.length,
            ),
          ),
      ],
    );
  }

  void _updateSubNameCallBack(String value, int index) {
    widget.localExtraMainIngredients.subCategoryList[index].name = value;
    widget.updateListCallBack(widget.localExtraMainIngredients, widget.index);
  }

  void _updateSubPriceCallBack(String value, int index) {
    widget.localExtraMainIngredients.subCategoryList[index].price = value != '' ? num.parse(value).toDouble() : 0.0;
    widget.updateListCallBack(widget.localExtraMainIngredients, widget.index);
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
