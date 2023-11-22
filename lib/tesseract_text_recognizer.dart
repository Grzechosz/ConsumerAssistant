import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:consciousconsumer/i_text_recognizer.dart';

class TesseractTextRecognizer extends ITextRecognizer {
  @override
  Future<String> processImage(String imgPath) async {
    final res = await FlutterTesseractOcr.extractText(imgPath,language: 'eng+pol', args: {
      // "psm": "4",
      "preserve_interword_spaces": "1",
    });
    return res;
  }
}