import 'package:consciousconsumer/databases/ingredients.dart';

import '../enums.dart';

class Ingredient{
  final int ?id;
  final String name;
  final Harmfulness harmfulness;
  final String description;
  final IngredientCategory category;
  DateTime? createdTime;
  DateTime? updatedTime;

  Ingredient({
    this.id,
    required this.name,
    required this.harmfulness,
    required this.description,
    required this.category
  });

  factory Ingredient.fromSqfliteDatabase(Map<String, dynamic> map) => Ingredient(
      id: map[IngredientProvider.columnId].toInt() ?? 0,
      name: map[IngredientProvider.columnName] ?? '',
      harmfulness: Harmfulness.good,
      description: map[IngredientProvider.columnDescription] ?? '',
      category: IngredientCategory.preservative);
}