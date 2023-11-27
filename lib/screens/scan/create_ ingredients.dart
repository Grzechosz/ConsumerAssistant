import 'dart:core';

class CreateProductIngredientsList {

  static Iterable ingredientsFilter(
      List<String> ingredients, List<dynamic> all) {
    return all.where((element) {
      bool check = false;
      for (String ingredient in ingredients) {
        ingredient = ingredient.replaceAll(RegExp(r'.*?\('), '');
        ingredient = ingredient.trim();
        ingredient = ingredient.replaceAll(RegExp(r'\)'), '');
        for (String name in element. names) {
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
