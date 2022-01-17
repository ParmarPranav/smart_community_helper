import 'package:flutter/material.dart';

class ImageErrorWidget extends StatefulWidget {
  @override
  _ImageErrorWidgetState createState() => _ImageErrorWidgetState();
}

class _ImageErrorWidgetState extends State<ImageErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Image not found',
            style: TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
