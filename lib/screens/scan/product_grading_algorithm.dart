import 'package:consciousconsumer/models/ingredient.dart';

class ProductGradingAlgorithm {
  ProductGradingAlgorithm();

  static double gradeProduct(List<Future<Ingredient>> ingredients) {
    double ingredientsNumber = ingredients.length.toDouble();
    double productScore = 0;
    for (Future<Ingredient> ingredient in ingredients) {
      ingredient.then((ing) {
        productScore += ing.harmfulness.id;
      });
    }
    if (productScore < ingredientsNumber) {
      return 1;
    } else if (productScore >= ingredientsNumber &&
        productScore < ingredientsNumber * 2) {
      return 0.66;
    } else if (productScore >= ingredientsNumber * 2 &&
        productScore < ingredientsNumber * 3) {
      return 0.33;
    } else if (productScore >= ingredientsNumber * 3) {
      return 0;
    }
    return 0; // in case of i dont know what;
  }
}
