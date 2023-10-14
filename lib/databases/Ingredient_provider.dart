// import 'package:consciousconsumer/models/ingredient.dart';
//
// import 'abstract_provider.dart';
//
// class IngredientProvider extends AbstractProvider {
//
//   static const tableName = 'ingredients';
//   static const columnId = 'ingredient_id';
//   static const columnName = 'name';
//   static const columnDescription = 'description';
//   static const columnHarmfulness = 'harmfulness';
//   static const columnCategory = 'category';
//   static const columnCreatedAt = 'created';
//   static const columnUpdatedAt = 'updated';
//
//   @override
//   Future<void> createTable(Database db) async {
//     await db.execute('''
//           CREATE TABLE IF NOT EXISTS $tableName (
//             $columnId INTEGER NOT NULL,
//             $columnName TEXT NOT NULL,
//             $columnHarmfulness TEXT NOT NULL,
//             $columnDescription TEXT NOT NULL,
//             $columnCategory TEXT NOT NULL,
//             $columnCreatedAt TEXT NOT NULL,
//             $columnUpdatedAt TEXT,
//             PRIMARY KEY($columnId AUTOINCREMENT)
//             );
//           ''');
//   }
//
//   @override
//   Future<int> create ({required var object}) async{
//     final db = await localDatabase.database;
//     final currentTime = DateTime.now().toString();
//     Ingredient ingredient = object as Ingredient;
//     return await db.rawInsert(
//       ''' INSERT INTO $tableName ($columnHarmfulness, $columnDescription, $columnCategory, $columnCreatedAt) VALUES (?,?,?,?,?)''',
//       [ingredient.harmfulness.name, ingredient.description, ingredient.category.name, currentTime]
//     );
//   }
//
//   Future<List<Ingredient>> fetchAll() async{
//     final ingredientsDatabase = await localDatabase.database;
//     final ingredients = await ingredientsDatabase.rawQuery(
//       ''' SELECT * FROM $tableName ''');
//     return ingredients.map((ingredient) => Ingredient.fromSqfliteDatabase(ingredient)).toList();
//  }
//
//  Future<Type> fetchById(int id) async {
//    final ingredientsDatabase = await localDatabase.database;
//     final ingredient = await ingredientsDatabase.rawQuery(
//       '''SELECT * FROM $tableName WHERE id = ?''', [id]
//     );
//     return Ingredient.fromSqfliteDatabase(ingredient.first);
//  }
//
//  // static void createDatabase(){
//  //    IngredientProvider provider = IngredientProvider();
//  //    provider.create(name: "Cukier",
//  //        harmfulness: Harmfulness.bad,
//  //        description: "Cukier to nic fajnego",
//  //        category: IngredientCategory.preservative);
//  //    provider.create(name: "Cukier1",
//  //        harmfulness: Harmfulness.bad,
//  //        description: "Cukier to nic fajnego1",
//  //        category: IngredientCategory.preservative);
//  //    provider.create(name: "Cukier11",
//  //        harmfulness: Harmfulness.bad,
//  //        description: "Cukier to nic fajnego11",
//  //        category: IngredientCategory.preservative);
//  //    provider.create(name: "Cukier111",
//  //        harmfulness: Harmfulness.bad,
//  //        description: "Cukier to nic fajnego111",
//  //        category: IngredientCategory.preservative);
//  //    provider.create(name: "Cukier1111",
//  //        harmfulness: Harmfulness.bad,
//  //        description: "Cukier to nic fajnego1111",
//  //        category: IngredientCategory.preservative);
//  // }
// }