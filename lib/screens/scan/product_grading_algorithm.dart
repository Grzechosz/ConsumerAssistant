import 'package:consciousconsumer/models/models.dart';

class ProductGradingAlgorithm {
  ProductGradingAlgorithm();

  static Future<double> gradeProduct(List<Future<Ingredient>> ingredients) async {
    double ingredientsNumber = ingredients.length.toDouble();
    double productScore = 0;
    for (Future<Ingredient> ingredient in ingredients) {
     await ingredient.then((ing) {
        if(ing.harmfulness.id == 3){
          return 3;
        }
        productScore += ing.harmfulness.id;
      });
    }
    if (productScore <= ingredientsNumber) {
      return 1;
    } else if (productScore > ingredientsNumber &&
        productScore <= ingredientsNumber * 2) {
      return 2;
    } else if (productScore > ingredientsNumber * 2 &&
        productScore <= ingredientsNumber * 3) {
      return 3;
    } else if (productScore > ingredientsNumber * 3) {
      return 4;
    }
    return 4; // in case of i dont know what;
  }
}
