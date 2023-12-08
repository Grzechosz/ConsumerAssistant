import 'dart:io';
import 'package:consciousconsumer/native_opencv.dart';
import 'package:consciousconsumer/screens/scan/process_image.dart';
import 'package:consciousconsumer/screens/scan/product_grading_algorithm.dart';
import 'package:consciousconsumer/text_recognition/tesseract_text_recognizer.dart';
import 'package:consciousconsumer/screens/scan/tricks_searcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:consciousconsumer/screens/loading_panel.dart';
import 'manage_product.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => ScannerScreenState();
}

class ScannerScreenState extends State<ScannerScreen> {
  File? _image;
  final picker = ImagePicker();
  late CroppedFile _croppedFile;
  late TextEditingController _textContoller;
  late TesseractTextRecognizer _tesseractTextRecognizer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textContoller = TextEditingController();
    _tesseractTextRecognizer = TesseractTextRecognizer();
  }

  @override
  void dispose() {
    _textContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Constants.sea80,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed: () async {
                  await useButton(true);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text("Zrób zdjęcie"),
              ),
              TextButton(
                onPressed: () async {
                  await useButton(false);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text("Wybierz z galerii"),
              )
            ]),
          ),
          Container(
              child: _isLoading
                  ? const LoaderPanel(isReversedColor: false)
                  : Container())
        ],
      ),
    );
  }

  Future useButton(bool takePhoto) async {
    if (takePhoto) {
      await getImageFromCamera().then((value) async {
        await _cropImage(_image!).then((value) async {
          _showLoadingIndicator();
          bool invertNeeded = isInvertNeeded(_croppedFile.path);
          if (invertNeeded) {
            invertImage(_croppedFile.path, _croppedFile.path);
          }
          processImage(_croppedFile.path, _croppedFile.path);
          await scanTextAndAddProduct();
        });
      });
    } else {
      await getImageFromGallery().then((value) async {
        await _cropImage(_image!).then((value) async {
          _showLoadingIndicator();
          await scanTextAndAddProduct();
        });
      });
    }
    _hideLoadingIndicator();
  }

  void _showLoadingIndicator() {
    print('isloading');
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoadingIndicator() {
    print('isNotloading');
    setState(() {
      _isLoading = false;
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<CroppedFile> _cropImage(File image) async {
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

  Future<bool> _navigateToProductManagementScreen(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManageProductWidget(
                  textEditingController: _textContoller,
                )));
  }

  List<String> splitDescription(String desc) {
    RegExp pattern = RegExp(r'\d+,\d+%');
    RegExp pattern2 = RegExp(r'.*?\(');
    RegExp pattern3 = RegExp(r'\)');
    RegExp pattern4 = RegExp(r'Sk?ładniki?:|Sk?ład');
    RegExp pattern5 = RegExp(r'\n');
    // int startIndex = desc.indexOf(pattern4);
    // int endIndex = desc.length;
    // List<String> result2 = [];

    // if (startIndex >= 0) {
    //   for (int i = startIndex; i < desc.length; i++) {
    //     var char = desc[i];
    //     if (char == ".") {
    //       endIndex = i;
    //       break;
    //     }
    //   }
    //   desc = desc.substring(startIndex + 10, endIndex);
    desc = desc.replaceAll(pattern, '');
    desc = desc.replaceAll(pattern5, '');
    // return [];
    return desc.split(",");
    // }
    // return [];
  }

  Future<void> scanTextAndAddProduct() async {
    await _tesseractTextRecognizer
        .processImage(_croppedFile.path)
        .then((value) async {
      List<String> ingredients = splitDescription(value); //["sól"]; //
      return ingredients;
    }).then((ingredients) async {
      if (ingredients.isNotEmpty) {
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

        _navigateToProductManagementScreen(context).then((result) async {
          if (result) {
            DateTime now = DateTime.now();
            String productId = now.toString();

            String remarks =
                TricksSearcher.checkSugarAndSweeteners(ingredientsList);

            XFile file = XFile(_image!.path);

            await ProcessImage.resizeImage(file);

            double productGrade =
                ProductGradingAlgorithm.gradeProduct(ingredientsList);
            Product scannedProduct = Product(_textContoller.text, productGrade,
                file.name, ingredientsList, now, remarks, productId);

            ProductsService(userId: FirebaseAuth.instance.currentUser!.uid)
                .uploadProduct(scannedProduct, file);
          }
        });
      } else {
        _showScanningErrorDialog();
      }
    });
  }
}
