
import '../screens/enums.dart';
import 'ingredient_name.dart';

class Ingredient{
  final int? id;
  final List<IngredientName>? names;
  final Harmfulness harmfulness;
  final String description;
  final IngredientCategory category;
  DateTime? createdTime;
  DateTime? updatedTime;

  Ingredient({
    this.id,
    required this.names,
    required this.harmfulness,
    required this.description,
    required this.category,
    required this.createdTime
  });

  // factory Ingredient.fromSqfliteDatabase(Map<String, dynamic> map) => Ingredient(
  //     id: map[IngredientProvider.columnId].toInt() ?? 0,
  //     names: null,
  //     harmfulness: Harmfulness.good,
  //     description: map[IngredientProvider.columnDescription] ?? '',
  //     category: IngredientCategory.preservative,
  //     createdTime: null);
}