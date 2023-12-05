import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:camera/camera.dart';
import 'package:image/image.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import '../../native_opencv.dart';

class ProcessImage {
  ProcessImage();

   static Future processImage(String path) async {
    await Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: path,
      kernelSize: 5,
    ).then((byte2) async {
      Image? decodedImage = decodeJpg(byte2!);
      await encodeImageFile(path, decodedImage!)
          .then((result) async {
        if (result) {
          await Cv2.adaptiveThreshold(
            pathFrom: CVPathFrom.GALLERY_CAMERA,
            pathString: path,
            maxValue: 255,
            adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
            thresholdType: Cv2.THRESH_BINARY,
            blockSize: 35,
            constantValue: 5,
          ).then((byte) {
            Image? binarizedImage = decodeJpg(byte);
            encodeImageFile(path, binarizedImage!);
          });
        }
      });
    });
  }

  static Future invertIfNeeded(String path) async {
    File file = File(path);

    // List<int> bytes =
    await file.readAsBytes().then((bytes) async {
      Image image = decodeImage(Uint8List.fromList(bytes))!;

      image = luminanceThreshold(image);

      List<int> histogram = List.filled(256, 0, growable: false);
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          Pixel pixel = image.getPixel(x, y);
          histogram[pixel.b.toInt()]++;
        }
      }

      Image image2 = decodeImage(Uint8List.fromList(bytes))!;

      if (histogram[0] > histogram[255]) {
        await invertColors(image2).then((value) => image2);
        dev.log("image need inversion of colors");
      } else  {
        dev.log("image do not need inversion of colors");
      }

      await encodeImageFile(path, image2);
    });
  }

  static Future<Image> invertColors(Image image) async {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        Pixel pixel = image.getPixel(x, y);
        Pixel invertedPixel = _invertColor(pixel);
        image.setPixel(x, y, invertedPixel);
      }
    }
    return Future.value(image);
  }

  static Pixel _invertColor(Pixel pixel) {
    pixel.r = 255 - pixel.r;
    pixel.g = 255 - pixel.g;
    pixel.b = 255 - pixel.b;
    return pixel;
  }

  static Future resizeImage(XFile image) async {
    await image.readAsBytes().then((value) async {
      Image? decodedImage = decodeImage(value);

      Image resizedImage = copyResize(decodedImage!, width: 300);
      await encodeImageFile(image.path, resizedImage);
    });
  }


}
