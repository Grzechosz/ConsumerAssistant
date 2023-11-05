
import 'enums.dart';

class Ingredient{
  final int id;
  final List<String> names;
  final Harmfulness harmfulness;
  final Category category;
  final String description;

  Ingredient({
    required this.id,
    required this.names,
    required this.harmfulness,
    required this.description,
    required this.category,
  });

  factory Ingredient.fromFirebase(Map<String, dynamic> map, int uid){
    final int id;
    final List<String> names = [];
    final String description;
    final Harmfulness harmfulness;
    final Category category;

    id=uid;
    for(dynamic name in map['names']){
      names.add(name as String);
    }
    description = map['description'] as String;
    String harmfulnessString = map['harmfulness'] as String;
    harmfulness
    = Harmfulness.values.firstWhere(
            (element) => element.toString() == 'Harmfulness.$harmfulnessString'
    );
    String categoryString = map['category'] as String;
    category
    = Category.values.firstWhere(
            (element) => element.toString() == 'Category.$categoryString'
    );
    return Ingredient(id: id,
        names: names,
        harmfulness: harmfulness,
        description: description,
        category: category);
  }
}