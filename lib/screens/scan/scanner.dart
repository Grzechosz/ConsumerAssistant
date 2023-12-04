import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/product.dart';
import 'package:consciousconsumer/screens/scan/create_%20ingredients.dart';
import 'package:consciousconsumer/screens/scan/manage_product.dart';
import 'package:consciousconsumer/screens/scan/process_image.dart';
import 'package:consciousconsumer/services/products_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/scan/tesseract_text_recognizer.dart';
import 'package:flutter/material.dart';
import '../home/Scanner.dart';
import '../loading.dart';
import '../../models/ingredient.dart';
import '../../services/ingredients_service.dart';
import '../../native_opencv.dart';

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
  late TextEditingController _textContoller;
  late TesseractTextRecognizer _tesseractTextRecognizer;
  late Future<void> _initializeControllerFuture;
  late CroppedFile _croppedFile;
  late List productIngredients;
  XFile? image;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _textContoller = TextEditingController();
    _initializeControllerFuture = _controller.initialize();
    _tesseractTextRecognizer = TesseractTextRecognizer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.done
                ? CameraPreview(_controller)
                : const Loading(isReversedColor: true));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        backgroundColor: Constants.sea,
        child: const Icon(Icons.camera_alt,),
      ),
    );
    // return
  }

  void _takePicture() async {
    {
      await _initializeControllerFuture;
      await _controller.setFocusMode(FocusMode.auto);
      await _controller.setExposureMode(ExposureMode.auto);
      await _controller.setFlashMode(FlashMode.off);
      final image = await _controller.takePicture();
      await _cropImage(image);
      bool isNeeded = isInvertNeeded(_croppedFile.path);
      if(isNeeded){
        invertImage(_croppedFile.path, _croppedFile.path);
      }
      // await ProcessImage.invertIfNeeded(_croppedFile.path);
      await ProcessImage.processImage(_croppedFile.path);

// processImage(_croppedFile.path, _croppedFile.path);
//      ingredients = [];
      String stringDesc = "";
      await _tesseractTextRecognizer
          .processImage(_croppedFile.path)
          .then((value) async {
        List<String> ingredients = splitDescription(value); //["sól"]; //
        stringDesc = value;
        return ingredients;
      }).then((ingredients) async {
        if(ingredients.isNotEmpty){
          List<Future<Ingredient>> ingredientsList = [];
          IngredientsService service = IngredientsService();
          RegExp pattern2 = RegExp(r'.*?\(|\)');
          for (String name in ingredients) {
            name = name.replaceAll(pattern2, '').trim();
            Ingredient? futureIngredient =
            await service.getIngredientByName(name.toLowerCase());
            if (futureIngredient != null) {
              ingredientsList.add(Future.value(futureIngredient));
            }
          }

          if (IngredientsService.isLoaded) {
            productIngredients = CreateProductIngredientsList.ingredientsFilter(
                ingredients, ingredientsList)
                .toList();
          }
          DateTime now = DateTime.now();
          String productId =
              now.toString() + FirebaseAuth.instance.currentUser!.uid;

          await ProcessImage.resizeImage(image);

          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ManageProductWidget(
                textEditingController: _textContoller,
                cameraController: _controller,
              )));


          Product scannedProduct = Product(_textContoller.text, 4, image.name,
              ingredientsList, now, "none", productId);

          ProductsService(userId: FirebaseAuth.instance.currentUser!.uid)
              .uploadProduct(scannedProduct, image);
        }
        else{
          // _showScanningErrorDialog();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(
                imagePath: _croppedFile.path,
                image_discription: stringDesc,
                // ingredientsList: ingredients,
              ),
            ),
          );
        }
      });
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPictureScreen(
      //       imagePath: _croppedFile.path,
      //       image_discription: stringDesc,
      //       ingredientsList: ingredients,
      //     ),
      //   ),
      // );
    }
  }

  Future<CroppedFile> _cropImage(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
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
    return croppedFile!;
  }

  List<String> splitDescription(String desc) {
    RegExp pattern = RegExp(r'\d+,\d+%');
    RegExp pattern2 = RegExp(r'.*?\(');
    RegExp pattern3 = RegExp(r'\)');
    RegExp pattern4 = RegExp(r'Sk?ładniki?:|Sk?ład');
    RegExp pattern5 = RegExp(r'\n');
    int startIndex = desc.indexOf(pattern4);
    int endIndex = 0;
    // List<String> result2 = [];

    if (startIndex >= 0) {
      for (int i = startIndex; i < desc.length; i++) {
        var char = desc[i];
        if (char == "." && endIndex == 0) {
          endIndex = i;
        }
      }
      desc = desc.substring(startIndex + 10, endIndex);
      desc = desc.replaceAll(pattern, '');
      desc = desc.replaceAll(pattern5, '');
      // return [];
      return  desc.split(",");
    }
    return [];
  }

  Future<void> _showScanningErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Błąd skanowania'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nie udało się odczytać składników.'),
                Text('Spróbuj ponownie zeskanować etykietę.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok', style: TextStyle(color: Constants.sea)),
              onPressed: () {
                Navigator.of(context).pop();
              },

            ),
          ],
        );
      },
    );
  }
}
