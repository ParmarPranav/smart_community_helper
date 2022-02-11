import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback itemHandler;

  const DrawerListTile({
    required this.iconData,
    required this.title,
    required this.itemHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[900],
      elevation: 1,
      margin: EdgeInsets.only(bottom: 2.0),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
            fontSize: 18,
            fontColor: Colors.white,
          ),
        ),
        onTap: itemHandler,
      ),
    );
  }
}
