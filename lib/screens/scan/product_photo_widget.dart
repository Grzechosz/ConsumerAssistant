import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../loading.dart';

class ProductPhotoWidget extends StatefulWidget{
  const ProductPhotoWidget({super.key, required this.cameraController});

  final CameraController cameraController;

  @override
  State<StatefulWidget> createState() => ProductPhotoWidgetState();
}

class ProductPhotoWidgetState extends State<ProductPhotoWidget> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:
      // FutureBuilder<void>(
      //     future: ,
      //     builder: (context, snapshot) {
      //       return (snapshot.connectionState == ConnectionState.done
      //           ? CameraPreview(widget.cameraController)
      //           : const Loading(isReversedColor: true));
      //     }),
      Text('Dodaj nazwę i zdjęcie'),
      // CameraPreview(widget.cameraController),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed:_takePicture,
      //   backgroundColor: Constants.sea,
      //   child: const Icon(
      //     Icons.camera_alt,
      //   ),
      // ),
    );
  }

void _takePicture() async {
    await widget.cameraController.setFocusMode(FocusMode.auto);
    await widget.cameraController.setExposureMode(ExposureMode.auto);
    await widget.cameraController.setFlashMode(FlashMode.off);
    final image = await widget.cameraController.takePicture();

    Navigator.pop(context);
}

}