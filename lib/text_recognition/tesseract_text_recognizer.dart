import 'package:consciousconsumer/text_recognition/text_recognizer.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';

class TesseractTextRecognizer extends ITextRecognizer {
  @override
  Future<String> processImage(String imgPath) async {
    final res = await FlutterTesseractOcr.extractText(imgPath,language: 'pol', args: {
      "psm": "6",
      "preserve_interword_spaces": "1",
    });
    return res;
  }
}