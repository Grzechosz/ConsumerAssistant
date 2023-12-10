import 'package:consciousconsumer/models/enums.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:consciousconsumer/screens/scan/tricks_searcher.dart';

void main() {

  test('Should find trick with sugar', () async{
    List<Future<Ingredient>> ingredients = [
      Future.value(Ingredient(id: 0,
          names: ['E300', 'Witamina B12'],
          harmfulness: Harmfulness.good,
          description: 'blabla',
          category: Category.sugars)),
      Future.value( Ingredient(id: 1,
          names: ['E512', 'Witamina C', 'Kwas Askorbinowy'],
          harmfulness: Harmfulness.good,
          description: 'blabla',
          category: Category.sugars),)
    ];
    String result = await TricksSearcher.checkSugarAndSweeteners(ingredients);
    expect(result == "Producent prawdopodobnie chce ukryć ilość słodzików rozbijając je na kilka składników", true);
  });



}