import 'dart:io';
import 'dart:typed_data';
import 'package:consciousconsumer/screens/create_%20ingredients.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/TesseractTextRecognizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:provider/provider.dart';
import '../../loading.dart';
import '../../models/ingredient.dart';
import '../../services/ingredients_service.dart';
import '../widgets/ingredients/ingredient_item.dart';

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
            await _controller.setFlashMode(FlashMode.off);
            final image = await _controller.takePicture();

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

            await _loadImage(_croppedFile!.path).then((value) async {
              // img.Image? imageee = img.decodeJpg(value!);
              await img
                  .encodeImageFile(image.path, value!)
                  .then((result) async {
                await Cv2.medianBlur(
                  pathFrom: CVPathFrom.GALLERY_CAMERA,
                  pathString: image!.path,
                  kernelSize: 5,
                ).then((byte2) async {
                  img.Image? imageee = img.decodeJpg(byte2!);

                  // await invertColors(imageee!).then((value) async{
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
                        blockSize: 29,
                        constantValue: 12,
                      ).then((byte) {
                        img.Image? imagee = img.decodeJpg(byte);
                        img.encodeImageFile(image.path, imagee!);
                      });
                    }
                  });
                });
              });
            });

            String stringDesc =
                await _tesseractTextRecognizer.processImage(image.path);

            List<String> ingriedients = splitDescription(stringDesc);
            // stringDesc = "";
            // for (String ingriedient in ingriedients) {
            //   stringDesc += "$ingriedient\n";
            // }

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  image_discription: stringDesc,
                  ingredientsList: ingriedients,
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

  List<String> splitDescription(String desc) {
    RegExp pattern = RegExp(r'\d+,\d+%');
    RegExp pattern2 = RegExp(r'.*?\(');
    RegExp pattern3 = RegExp(r'\)');
    RegExp pattern4 = RegExp(r'Sk?ładniki?:');
    RegExp pattern5 = RegExp(r'\n');
    int startIndex = desc.indexOf(pattern4);
    int endIndex = 0;

    for (int i = 0; i < desc.length; i++) {
      var char = desc[i];
      if (char == "." && endIndex == 0) {
        endIndex = i;
      }
    }

    desc = desc.substring(startIndex + 10, endIndex);
    desc = desc.replaceAll(pattern, '');
    desc = desc.replaceAll(pattern5, '');

    List<String> result = desc.split(",");

    for (var element in result) {
      element = element.replaceAll(pattern2, '');
      element = element.replaceAll(pattern3, '');
    }
    return result;
  }

  Future<img.Image> _loadImage(String localPath) async {
    File file = File(localPath);
    List<int> bytes = await file.readAsBytes();
    // List<int> bytes = data.buffer.asUint8List();

    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    // Invert the colors
    return Future.value(invertColors(image));
  }

  img.Image invertColors(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);
        img.Pixel invertedPixel = _invertColor(pixel);
        image.setPixel(x, y, invertedPixel);
      }
    }
    return image;
  }

  img.Pixel _invertColor(img.Pixel pixel) {
    pixel.r = 255 - pixel.r;
    pixel.g = 255 - pixel.g;
    pixel.b = 255 - pixel.b;
    return pixel;
  }
}

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.image_discription,
      required this.ingredientsList});
  @override
  State<StatefulWidget> createState() => DisplayPictureScreenState();

  final String imagePath;
  final String image_discription;
  final List<String> ingredientsList;
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late List allIngredients;
  late List ingredients;
  // const DisplayPictureScreen(
  //     {super.key, required this.imagePath, required this.image_discription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(widget.imagePath)),
          // SingleChildScrollView(child: Text(widget.image_discription)),
          _buildIngredients()
        ],
      ),
    );
  }

  StreamProvider _buildIngredients() {
    return StreamProvider<List<Ingredient>>.value(
      value: IngredientsService().ingredients,
      initialData: const [],
      builder: (context, child) {
        return Expanded(
          child: _buildIngredientsList(context),
        );
      },
    );
  }

  Widget _buildIngredientsList(BuildContext context) {
    allIngredients = Provider.of<List<Ingredient>>(context);
    // List<String> ingred = ["witamina C", "witamina E"];
    if (IngredientsService.isLoaded) {
      ingredients = CreateProductIngredientsList.ingredientsFilter(
              widget.ingredientsList, allIngredients)
          .toList();
      // ingredients = SortingAndFiltering.ingredientsFilter(searchText, allIngredients).toList();
      // SortingAndFiltering.sort(selectedSortOption, ingredients, isDownwardArrow);
      return ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return (ingredients.isEmpty
              ? const Center(
                  child: Text("Brak składników"),
                )
              : ListTile(title: IngredientItem(ingredients[index])));
        },
      );
    } else {
      return const Loading(isReversedColor: false);
    }
  }
}
