import 'dart:io';
import 'dart:typed_data';
import 'package:consciousconsumer/screens/scan/create_%20ingredients.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/scan/tesseract_text_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:provider/provider.dart';
import '../loading.dart';
import '../../models/ingredient.dart';
import '../../services/ingredients_service.dart';
import '../ingredients/ingredient_item.dart';

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
  late CroppedFile _croppedFile;
  XFile? image;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
    _tesseractTextRecognizer = TesseractTextRecognizer();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  void _takePicture() async {
    {
      await _initializeControllerFuture;
      await _controller.setFocusMode(FocusMode.auto);
      await _controller.setExposureMode(ExposureMode.auto);
      await _controller.setFlashMode(FlashMode.off);
      final image = await _controller.takePicture();
      await _cropImage(image);
      await _invertIfNeeded(image);
      await _processImage(image);

      List<String> ingredients = [];
      String stringDesc = "";
      await _tesseractTextRecognizer
          .processImage(_croppedFile.path)
          .then((value) async {
        ingredients = splitDescription(value);// ["sól"]; //
        stringDesc = value;
      });

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: _croppedFile.path,
            image_discription: stringDesc,
            ingredientsList: ingredients,
          ),
        ),
      );
    }
  }

  Future _processImage(XFile image) async {
    await Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: _croppedFile.path,
      kernelSize: 5,
    ).then((byte2) async {
      img.Image? imageee = img.decodeJpg(byte2!);
      await img
          .encodeImageFile(_croppedFile.path, imageee!)
          .then((result) async {
        if (result) {
          await Cv2.adaptiveThreshold(
            pathFrom: CVPathFrom.GALLERY_CAMERA,
            pathString: _croppedFile.path,
            maxValue: 255,
            adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
            thresholdType: Cv2.THRESH_BINARY,
            blockSize: 29,
            constantValue: 12,
          ).then((byte) {
            img.Image? imagee = img.decodeJpg(byte);
            img.encodeImageFile(_croppedFile.path, imagee!);
          });
        }
      });
    });
  }

  Future _invertIfNeeded(XFile file) async {
    File file = File(_croppedFile.path);
    // List<int> bytes =
    await file.readAsBytes().then((bytes) async {
      img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

      image = img.luminanceThreshold(image);

      List<int> histogram = List.filled(256, 0, growable: false);
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          img.Pixel pixel = image.getPixel(x, y);
          histogram[pixel.b.toInt()]++;
        }
      }

      img.Image image2 = img.decodeImage(Uint8List.fromList(bytes))!;

      if (histogram[0] > histogram[255]) {
        await invertColors(image2).then((value) => image2);
        print("needed");
      } else {
        print("not needed");
      }

     await img.encodeImageFile(_croppedFile.path, image2);
    });
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

  _imageTransformations() {
    // await _loadImage(_croppedFile!.path).then((value) async {
    //   // img.Image? imageee = img.decodeJpg(value!);
    //   await img
    //       .encodeImageFile(image.path, value!)
    //       .then((result) async {
    Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: _croppedFile.path,
      kernelSize: 5,
    ).then((byte2) {
      img.Image? imageee = img.decodeJpg(byte2!);

      // await invertColors(imageee!).then((value) async{
      img.encodeImageFile(_croppedFile.path, imageee!).then((result) {
        if (result) {
          Cv2.adaptiveThreshold(
            pathFrom: CVPathFrom.GALLERY_CAMERA,
            pathString: _croppedFile.path,
            maxValue: 255,
            adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
            thresholdType: Cv2.THRESH_BINARY,
            blockSize: 29,
            constantValue: 12,
          ).then((byte) {
            img.Image? imagee = img.decodeJpg(byte);
            setState(() {
              img.encodeImageFile(_croppedFile.path, imagee!);
            });
          });
        }
      });
    });
    //   });
    // });
    return _croppedFile;
  }

  List<String> splitDescription(String desc) {
    RegExp pattern = RegExp(r'\d+,\d+%');
    RegExp pattern2 = RegExp(r'.*?\(');
    RegExp pattern3 = RegExp(r'\)');
    RegExp pattern4 = RegExp(r'Sk?ładniki?:');
    RegExp pattern5 = RegExp(r'\n');
    int startIndex = desc.indexOf(pattern4);
    int endIndex = 0;
    if (startIndex >= 0) {
      for (int i = startIndex; i < desc.length; i++) {
        var char = desc[i];
        if (char == "." && endIndex == 0) {
          endIndex = i;
        }
      }
    } else {
      print("oops");
    }

    desc = desc.substring(startIndex + 10, endIndex);

    /// XDDDDDDDDDDDDDDDDDDDDDDDDDDDD A JEŚLI MA MNIEJ NIŻ 10 ZNAKÓW???
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
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    return Future.value(invertColors(image));
  }

  Future<img.Image> invertColors(img.Image image) async {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);
        img.Pixel invertedPixel = _invertColor(pixel);
        image.setPixel(x, y, invertedPixel);
      }
    }
    return Future.value(image);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
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
    if (IngredientsService.isLoaded) {
      ingredients = CreateProductIngredientsList.ingredientsFilter(
              widget.ingredientsList, allIngredients)
          .toList();
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
