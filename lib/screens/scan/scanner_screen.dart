import 'dart:io';
import 'package:consciousconsumer/native_opencv.dart';
import 'package:consciousconsumer/screens/scan/process_image.dart';
import 'package:consciousconsumer/screens/scan/product_grading_algorithm.dart';
import 'package:consciousconsumer/text_recognition/tesseract_text_recognizer.dart';
import 'package:consciousconsumer/screens/scan/tricks_searcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:consciousconsumer/screens/loading_panel.dart';
import 'manage_product.dart';

class ScannerScreen extends HookWidget {
  const ScannerScreen({super.key, required this.backToProducts});

  final VoidCallback backToProducts;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final isLoading = useState(false);
    final image = useState<File?>(null);
    final croppedFile = useState<CroppedFile?>(null);
    final tesseractTextRecognizer = useState(TesseractTextRecognizer());
    final picker = useState(ImagePicker());
    bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Constants.sea80,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              isEmailVerified
                  ? const Text('')
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.transparent),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: const Text(
                        'Zweryfikuj email aby korzystać z aplikacji!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: Constants.titleSize,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
              isEmailVerified
                  ? TextButton(
                      onPressed: () async {
                        await useButton(context, true, () {
                          isLoading.value = !isLoading.value;
                        }, image, croppedFile, tesseractTextRecognizer, picker);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      child: const Text(
                        "Zrób zdjęcie",
                        style: TextStyle(
                            color: Constants.dark,
                            fontSize: Constants.titleSize),
                      ),
                    )
                  : const TextButton(
                      onPressed: null,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      child: Text(
                        "Zrób zdjęcie",
                        style: TextStyle(
                            color: Constants.dark50,
                            fontSize: Constants.titleSize),
                      ),
                    ),
              isEmailVerified
                  ? TextButton(
                      onPressed: () async {
                        await useButton(context, false, () {
                          isLoading.value = !isLoading.value;
                        }, image, croppedFile, tesseractTextRecognizer, picker);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      child: const Text(
                        "Wybierz z galerii",
                        style: TextStyle(
                            color: Constants.dark,
                            fontSize: Constants.titleSize),
                      ),
                    )
                  : const TextButton(
                      onPressed: null,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      child: Text(
                        "Wybierz z galerii",
                        style: TextStyle(
                            color: Constants.dark50,
                            fontSize: Constants.titleSize),
                      ),
                    )
            ]),
          ),
          Container(
              child: isLoading.value
                  ? const LoaderPanel(isReversedColor: false)
                  : Container())
        ],
      ),
    );
  }

  Future useButton(
      BuildContext context,
      bool takePhoto,
      VoidCallback function,
      ValueNotifier<File?> image,
      ValueNotifier<CroppedFile?> croppedFile,
      ValueNotifier<TesseractTextRecognizer> tesseractTextRecognizer,
      ValueNotifier<ImagePicker> picker) async {
    if (takePhoto) {
      await getImageFromCamera(image, picker).then((value) async {
        await _cropImage(image.value, croppedFile).then((value) async {
          function();
          bool invertNeeded = isInvertNeeded(croppedFile.value!.path);
          if (invertNeeded) {
            invertImage(croppedFile.value!.path, croppedFile.value!.path);
          }
          processImage(croppedFile.value!.path, croppedFile.value!.path);
          await scanTextAndAddProduct(context, image.value,
              croppedFile.value!.path, tesseractTextRecognizer);
        });
      });
    } else {
      await getImageFromGallery(image, picker).then((value) async {
        await _cropImage(image.value, croppedFile).then((value) async {
          function();
          bool invertNeeded = isInvertNeeded(croppedFile.value!.path);
          if (invertNeeded) {
            invertImage(croppedFile.value!.path, croppedFile.value!.path);
          }
          processImage(croppedFile.value!.path, croppedFile.value!.path);
          await scanTextAndAddProduct(context, image.value,
              croppedFile.value!.path, tesseractTextRecognizer);
        });
      });
    }
    function();
  }

  Future getImageFromGallery(
      ValueNotifier<File?> image, ValueNotifier<ImagePicker> picker) async {
    final pickedFile =
        await picker.value.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future getImageFromCamera(
      ValueNotifier<File?> image, ValueNotifier<ImagePicker> picker) async {
    final pickedFile = await picker.value.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<CroppedFile?> _cropImage(
      File? image, ValueNotifier<CroppedFile?> cropped) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            // hideBottomControls: true,
            activeControlsWidgetColor: Colors.blueAccent,
            lockAspectRatio: false),
      ],
    );
    if (croppedFile != null) {
      cropped.value = croppedFile;
    }
    return cropped.value;
  }

  Future<void> _showScanningErrorDialog(BuildContext context) async {
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

  Future<String> _navigateToProductManagementScreen(
      BuildContext context) async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageProductWidget()));
  }

  List<String> splitDescription(String desc) {
    RegExp pattern = RegExp(r'\d+,\d+%');
    RegExp pattern5 = RegExp(r'\n');
    RegExp delimiters = RegExp(r';|:|\.|\*|\si\s|\]');
    desc = desc.replaceAll(delimiters, ",");
    desc = desc.replaceAll(pattern, ',');
    desc = desc.replaceAll(pattern5, ' ');
    return desc.split(",");
  }

  Future<void> scanTextAndAddProduct(
      BuildContext context,
      File? image,
      String path,
      ValueNotifier<TesseractTextRecognizer> tesseractTextRecognizer) async {
    await tesseractTextRecognizer.value.processImage(path).then((value) async {
      List<String> ingredients = splitDescription(value); //["sól"]; //
      return ingredients;
    }).then((ingredients) async {
      if (ingredients.isNotEmpty) {
        List<Ingredient> ingredientsList = [];
        List<Future<Ingredient>> futureIngredientsList = [];
        IngredientsService service = IngredientsService();
        RegExp pattern2 = RegExp(r'.*?\(|\)|.*?\[');
        RegExp patternEXXX = RegExp(r'E\d{3}');
        for (String name in ingredients) {
          name = name.replaceAll(pattern2, '').trim();
          Ingredient? ingredientFromFirebase;
          if(patternEXXX.hasMatch(name)){
            ingredientFromFirebase = await service.getIngredientByName(name);
          }else{
            ingredientFromFirebase = await service.getIngredientByName(name.toLowerCase());
          }
          if (ingredientFromFirebase != null) {
            ingredientsList.add(ingredientFromFirebase);
          }
        }
        List toDelete = [];
        List ingredientsToSave = [];
        ingredientsList.forEach((element) => ingredientsToSave.add(element));
        ingredientsList.sort((ing1, ing2) {
          return ing1.names[0].compareTo(ing2.names[0]);
        });
        Ingredient prev = ingredientsList[0];
        for (int i = 1; i < ingredientsList.length; i++) {
          if (ingredientsList[i].names[0].compareTo(prev.names[0]) == 0) {
            toDelete.add(ingredientsList[i]);
          }
          prev = ingredientsList[i];
        }
        for (Ingredient delete in toDelete) {
          ingredientsToSave.remove(delete);
        }

        for (Ingredient ing in ingredientsToSave) {
          futureIngredientsList.add(Future.value(ing));
        }

        _navigateToProductManagementScreen(context).then((result) async {
          if (result.isNotEmpty) {
            DateTime now = DateTime.now();
            String productId = now.toString();

            String remarks = await TricksSearcher.checkSugarAndSweeteners(
                futureIngredientsList);

            XFile file = XFile(image!.path);

            await ProcessImage.resizeImage(file);

            double productGrade = await
                ProductGradingAlgorithm.gradeProduct(futureIngredientsList);
            final scannedProduct = Product(
              result,
              productGrade,
              file.name,
              futureIngredientsList,
              now,
              remarks,
              productId,
            );

            ProductsService(userId: FirebaseAuth.instance.currentUser!.uid)
                .uploadProduct(scannedProduct, file);
            backToProducts();
          }
        });
      } else {
        _showScanningErrorDialog(context);
      }
    });
  }
}
