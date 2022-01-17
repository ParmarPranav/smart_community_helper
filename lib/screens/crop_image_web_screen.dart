import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropImageWebScreen extends StatefulWidget {
  static const routeName = '/crop-image-web';

  @override
  _CropImageWebScreenState createState() => _CropImageWebScreenState();
}

class _CropImageWebScreenState extends State<CropImageWebScreen> {
  bool _isInit = true;

  late Uint8List imageData;
  final _controller = CropController();

  var _isProcessing = false;

  set isProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Uint8List? _croppedData;

  set croppedData(Uint8List value) {
    setState(() {
      _croppedData = value;
    });
  }

  var _isPreviewing = false;

  set isPreviewing(bool value) {
    setState(() {
      _isPreviewing = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final image = ModalRoute.of(context)!.settings.arguments as Uint8List;
      imageData = image;
      setState(() {});
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        title: Text(
          'Crop Your Image',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Visibility(
        visible: imageData != null && !_isProcessing,
        child: imageData != null
            ? Visibility(
                visible: _croppedData == null,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Crop(
                            controller: _controller,
                            image: imageData,
                            onCropped: (cropped) async {
                              croppedData = cropped;
                              isProcessing = false;
                              Navigator.of(context).pop(cropped);
                            },
                            initialSize: 0.5,
                            cornerDotBuilder: (size, cornerIndex) {
                              return _isPreviewing ? const SizedBox.shrink() : const DotControl();
                            },
                            maskColor: _isPreviewing ? Colors.white : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          isProcessing = true;
                          _controller.crop();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          primary: Theme.of(context).primaryColor,
                          onPrimary: Colors.white,
                        ),
                        child: Text('Crop'),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
                replacement: const SizedBox.shrink(),
              )
            : const SizedBox.shrink(),
        replacement: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
