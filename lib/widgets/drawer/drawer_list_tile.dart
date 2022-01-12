import 'package:flutter/material.dart';

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
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: itemHandler,
      ),
    );
  }
}
