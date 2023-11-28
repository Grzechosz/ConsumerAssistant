import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ManageProductWidget extends StatefulWidget {
  const ManageProductWidget({super.key, required this.textEditingController, required this.cameraController});

  final TextEditingController textEditingController;
  final CameraController cameraController;

  @override
  State<StatefulWidget> createState() => ManageProductWidgetState();
}

class ManageProductWidgetState extends State<ManageProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(  children: <Widget>[
        const Text('Manage Product Card'),
        TextField(
          controller: widget.textEditingController,
        ),
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            _takePicture;
            Navigator.of(context).pop();
          },
        ),
      ],
      ),
    );

  }

  void _takePicture() async {
      await widget.cameraController.setFocusMode(FocusMode.auto);
      await widget.cameraController.setExposureMode(ExposureMode.auto);
      await widget.cameraController.setFlashMode(FlashMode.off);
      final image = await widget.cameraController.takePicture();
  }
}
