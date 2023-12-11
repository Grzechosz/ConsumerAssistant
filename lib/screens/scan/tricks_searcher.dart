import 'package:consciousconsumer/models/models.dart';

class TricksSearcher {
  TricksSearcher();

  static Future<String> checkSugarAndSweeteners(List<Future<Ingredient>> ingredients) async {
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
}
