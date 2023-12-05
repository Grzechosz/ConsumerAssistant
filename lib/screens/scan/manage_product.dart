import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/scan/product_photo_widget.dart';
import 'package:flutter/material.dart';

class ManageProductWidget extends StatefulWidget {
  const ManageProductWidget({super.key, required this.textEditingController, required this.cameraController});

  final TextEditingController textEditingController;
  final CameraController cameraController;

  @override
  State<StatefulWidget> createState() => ManageProductWidgetState();
}

class ManageProductWidgetState extends State<ManageProductWidget> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Dodaj nazwę'),   //    i zdjęcie
          TextField(
            controller: widget.textEditingController,
          ),
          TextButton(
            child: const Text('Anuluj'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text('Gotowe'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          // TextButton(
          //   child: const Text('Zrób zdjęcie'),
          //   onPressed: () {
          //     _navigateToProductPhotoScreen;
          //   },
          // ),
        ],
      ),
    );
  }

  Future<void> _navigateToProductPhotoScreen(BuildContext context) async {
     await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductPhotoWidget(
              cameraController : widget.cameraController,
            )));
  }

  // void _takePicture() async {
  //     await widget.cameraController.setFocusMode(FocusMode.auto);
  //     await widget.cameraController.setExposureMode(ExposureMode.auto);
  //     await widget.cameraController.setFlashMode(FlashMode.off);
  //     final image = await widget.cameraController.takePicture();
  //
  //     Navigator.pop(context, image.path);
  // }
}
