import 'package:consciousconsumer/models/models.dart';

class TricksSearcher {
  TricksSearcher();

  static Future<String> checkSugarAndSweeteners(
      List<Future<Ingredient>> ingredients) async {
    int countOfSweetIngredients = 0;
    for (Future<Ingredient> ingredient in ingredients) {
      Ingredient ing = await ingredient;
      if (ing.category.name == 'sugars') {
        countOfSweetIngredients++;
      }
    }
    if (countOfSweetIngredients > 1) {
      return "Producent prawdopodobnie chce ukryć ilość słodzików rozbijając je na kilka składników";
    }
    return "";
  }

  static Future<String> checkButterTrick(String ocrText) async {
    RegExp pattern1 = RegExp(r'tłuszcz roślinny|tluszcz roslinny|uszcz roslinny');
    RegExp pattern2 = RegExp(r'tłuszcz mleczny|tluszcz mleczny|uszcz mleczny');

    if (pattern1.hasMatch(ocrText) && pattern2.hasMatch(ocrText)) {
      return "Producent dodaje do produktu tłuszcze roślinne aby ukryć małą zawartość tłuszczu mlecznego";
    }
    return "";
  }
}
