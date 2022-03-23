import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

import '../../models/local_removable_ingredients.dart';

class LocalRemovableIngredientsWidget extends StatefulWidget {
  final int index;
  final LocalRemovableIngredients localRemovableIngredients;
  final Function updateTextCallBack;
  final Function updateListCallBack;
  final Function deleteCallBack;

  LocalRemovableIngredientsWidget({
    required this.index,
    required this.localRemovableIngredients,
    required this.updateTextCallBack,
    required this.updateListCallBack,
    required this.deleteCallBack,
  });

  @override
  _LocalRemovableIngredientsWidgetState createState() => _LocalRemovableIngredientsWidgetState();
}

class _LocalRemovableIngredientsWidgetState extends State<LocalRemovableIngredientsWidget> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.localRemovableIngredients.name;
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
              backgroundColor: widget.localRemovableIngredients.color,
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
                hintText: 'Enter a removable-ingredient name',
                hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                  fontSize: 16,
                  fontColor: Colors.grey,
                ),
                border: InputBorder.none,
              ),
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
