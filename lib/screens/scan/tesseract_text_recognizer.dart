import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:consciousconsumer/screens/scan/text_recognizer.dart';

class TesseractTextRecognizer extends ITextRecognizer {
  @override
  Future<String> processImage(String imgPath) async {
    final res = await FlutterTesseractOcr.extractText(imgPath,language: 'eng+pol', args: {
      "psm": "6",
      "preserve_interword_spaces": "1",
    });
    return res;
  }
}