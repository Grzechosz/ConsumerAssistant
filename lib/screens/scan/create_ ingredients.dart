import 'dart:core';

class CreateProductIngredientsList {

  static Iterable ingredientsFilter(
      List<String> ingredients, List<dynamic> all) {
    List<String> clearedIngredients = [];
    for (String ingredient in ingredients) {
      ingredient = ingredient.replaceAll(RegExp(r'.*?\('), '');
      ingredient = ingredient.trim();
      ingredient = ingredient.replaceAll(RegExp(r'\)'), '');
      clearedIngredients.add(ingredient);
    }
    return all.where((element) {
      bool check = false;
      for (String name in element. names) {
          for(String ingredient in clearedIngredients){
            name.toLowerCase().compareTo(ingredient.toLowerCase()) == 0 ? check=true : check = false;
            if (check) {
              return true;
            }
          }
        }
      return check;
    });
  }
}
