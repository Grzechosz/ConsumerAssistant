import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:camera/camera.dart';
import 'package:image/image.dart';

class ProcessImage {
  ProcessImage();

    static Future resizeImage(XFile image) async {
    await image.readAsBytes().then((value) async {
      Image? decodedImage = decodeImage(value);

      Image resizedImage = copyResize(decodedImage!, width: 300);
      await encodeImageFile(image.path, resizedImage);
    });
  }
}
