import 'package:consciousconsumer/models/models.dart';

class TricksSearcher {
  TricksSearcher();

  static String checkSugarAndSweeteners(List<Future<Ingredient>> ingredients) {
    int countOfSweetIngredients = 0;
    for (Future<Ingredient> ingredient in ingredients) {
      ingredient.then((ing) {
        if (ing.category.name == "sweeteners") {
          countOfSweetIngredients++;
        }
      });
    }
    if (countOfSweetIngredients > 1) {
      return "Producent prawdopodobnie chce ukryć ilość słodzików rozbijając je na kilka składników";
    }
    return "Nie wykryto triku 'rozbicie cukru na składniki'";
  }
}
