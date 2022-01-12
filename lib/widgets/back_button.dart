import 'package:flutter/material.dart';

class BackButtonNew extends StatelessWidget {
  final VoidCallback onTap;

  const BackButtonNew({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_left_sharp,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Back',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
