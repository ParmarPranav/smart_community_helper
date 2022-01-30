import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/local_choosable_main_ingredients.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/restaurant/local_choosable_sub_ingredients_widget.dart';

class LocalChoosableMainIngredientsWidget extends StatefulWidget {
  final int index;
  final LocalChoosableMainIngredients localChoosableMainIngredients;
  final Function updateTextCallBack;
  final Function updateListCallBack;
  final Function addSubCallBack;
  final Function deleteCallBack;
  final Function deleteSubCallBack;

  LocalChoosableMainIngredientsWidget({
    required this.index,
    required this.localChoosableMainIngredients,
    required this.updateTextCallBack,
    required this.updateListCallBack,
    required this.addSubCallBack,
    required this.deleteCallBack,
    required this.deleteSubCallBack,
  });

  @override
  _LocalChoosableMainIngredientsWidgetState createState() => _LocalChoosableMainIngredientsWidgetState();
}

class _LocalChoosableMainIngredientsWidgetState extends State<LocalChoosableMainIngredientsWidget> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.localChoosableMainIngredients.name;
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
              backgroundColor: widget.localChoosableMainIngredients.color,
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
        if (widget.localChoosableMainIngredients.subCategoryList.length > 0)
          Container(
            margin: EdgeInsets.only(left: 70, top: 8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LocalChoosableSubIngredientsWidget(
                  index: index,
                  localChoosableSubIngredients: widget.localChoosableMainIngredients.subCategoryList[index],
                  updateTextCallBack: (value) => _updateSubTextCallBack(value, index),
                  addCallBack: () {
                    widget.addSubCallBack(widget.index);
                  },
                  deleteCallBack: (index) {
                    widget.deleteSubCallBack(widget.index, index);
                  },
                  subCategoryList: widget.localChoosableMainIngredients.subCategoryList,
                );
              },
              itemCount: widget.localChoosableMainIngredients.subCategoryList.length,
            ),
          ),
      ],
    );
  }

  void _updateSubTextCallBack(String value, int index) {
    widget.localChoosableMainIngredients.subCategoryList[index].name = value;
    widget.updateListCallBack(widget.localChoosableMainIngredients, widget.index);
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
