import 'package:consciousconsumer/models/enums.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:consciousconsumer/screens/ingredients/sorting_and_filtering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Searching should return 3 results', () {
    List<Ingredient> list = [Ingredient(id: 0,
        names: ['E300', 'Witamina B12'],
        harmfulness: Harmfulness.good,
        description: 'blabla',
        category: Category.enhancers),
      Ingredient(id: 1,
          names: ['E512', 'Witamina C', 'Kwas Askorbinowy'],
          harmfulness: Harmfulness.good,
          description: 'blabla',
          category: Category.enhancers),
      Ingredient(id: 2,
          names: ['E302', 'Prowitamina D', 'Xoxo'],
          harmfulness: Harmfulness.good,
          description: 'blabla',
          category: Category.enhancers),
      Ingredient(id: 3,
          names: ['E317', 'Aspiryna', 'Paracetamol'],
          harmfulness: Harmfulness.good,
          description: 'blabla',
          category: Category.enhancers),
    ];
    List resultsList = SortingAndFiltering.ingredientsFilter('wit', list).toList();
    expect(resultsList.length==3, true);
  });
}