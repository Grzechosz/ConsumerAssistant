import 'dart:io';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/TesseractTextRecognizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  ScannerScreenState createState() => ScannerScreenState();
}

class ScannerScreenState extends State<ScannerScreen> {
  late CameraController _controller;
  late TesseractTextRecognizer _tesseractTextRecognizer;
  late Future<void> _initializeControllerFuture;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _tesseractTextRecognizer = TesseractTextRecognizer();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.

            // await _controller.setFocusMode(FocusMode.locked);
            // await _controller.setExposureMode(ExposureMode.locked);
            await _controller.setFocusMode(FocusMode.auto);
            await _controller.setExposureMode(ExposureMode.auto);
            final image = await _controller.takePicture();

            if (image != null) {
              final croppedFile = await ImageCropper().cropImage(
                sourcePath: image!.path,
                compressFormat: ImageCompressFormat.jpg,
                compressQuality: 100,
                uiSettings: [
                  AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: Colors.blueAccent,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.original,
                      hideBottomControls: true,
                      lockAspectRatio: false),
                ],
              );
              if (croppedFile != null) {
                setState(() {
                  _croppedFile = croppedFile;
                });
              }
            }

            await Cv2.medianBlur(
              pathFrom: CVPathFrom.GALLERY_CAMERA,
              pathString: _croppedFile!.path,
              kernelSize: 5,
            ).then((byte2) async {
              img.Image? imageee = img.decodeImage(byte2!);
              await img
                  .encodeImageFile(image.path, imageee!)
                  .then((result) async {
                if (result) {
                  await Cv2.adaptiveThreshold(
                    pathFrom: CVPathFrom.GALLERY_CAMERA,
                    pathString: image.path,
                    maxValue: 255,
                    adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                    thresholdType: Cv2.THRESH_BINARY,
                    blockSize: 39,
                    constantValue:15,
                  ).then((byte) {
                    img.Image? imagee = img.decodeImage(byte);
                    img.encodeImageFile(image.path, imagee!);
                  });
                }
              });
            });

            // Uint8List? bytes = await image.readAsBytes();
            // img.Image? imagee = img.decodeImage(_byte);
            // // img.grayscale(imagee!);
            // // img.luminanceThreshold(imagee);
            // img.encodeImageFile(image.path, imagee!);
            // }

            final stringDesc =
                await _tesseractTextRecognizer.processImage(image.path);

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  image_discription: stringDesc,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<Uint8List> blurImage(String path) async {
    Future<Uint8List> _byte2 = (await Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: path,
      kernelSize: 5,
    )) as Future<Uint8List>;
    return _byte2;
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String image_discription;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.image_discription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(imagePath)),
          SingleChildScrollView(child: Text(image_discription))
        ],
      ),
    );
  }
}
