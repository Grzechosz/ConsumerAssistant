import 'package:consciousconsumer/enums.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IngredientProvider {
  final _databaseName = "ingredients.db";
  final _databaseVersion = 1;

  final tableName = 'ingredients';

  static const columnId = 'ingredient_id';
  static const columnName = 'name';
  static const columnDescription = 'description';
  static const columnHarmfulness = 'harmfulness';
  static const columnCategory = 'category';
  static const columnCreatedAt = 'created';
  static const columnUpdatedAt = 'updated';

  Database? _ingredientsDatabase;

  Future<Database> get database async {
    if (_ingredientsDatabase != null) {
      return _ingredientsDatabase!;
    }
    _ingredientsDatabase = await _init();
    return _ingredientsDatabase!;
  }

  Future<String> get fullPath async {
    return join(await getDatabasesPath(),
        _databaseName);
  }

  Future <Database> _init() async {
    var database = await openDatabase(
        await fullPath,
        version: _databaseVersion,
        onCreate: _onCreate,
        singleInstance: true
    );
    return database;
  }

  Future _onCreate(Database db, int version) async{
    await createTable(db);
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            $columnId INTEGER NOT NULL,
            $columnName TEXT NOT NULL,
            $columnHarmfulness TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            PRIMARY KEY($columnId AUTOINCREMENT)
            );
          ''');
  }

  Future<int> create ({
    required String name,
    required Harmfulness harmfulness,
    required String description,
    required IngredientCategory category}) async{
    final ingredientsDatabase = await database;
    return await ingredientsDatabase.rawInsert(
      ''' INSERT INTO $tableName ($columnName, $columnHarmfulness, $columnDescription, $columnCategory) VALUES (?,?,?,?)''',
      [name, harmfulness.name, description, category.name]
    );
  }

  Future<List<Ingredient>> fetchAll() async{
    final ingredientsDatabase = await database;
    final ingredients = await ingredientsDatabase.rawQuery(
      ''' SELECT * FROM $tableName ''');
    return ingredients.map((ingredient) => Ingredient.fromSqfliteDatabase(ingredient)).toList();
 }

 Future<Ingredient> fetchById(int id) async {
   final ingredientsDatabase = await database;
    final ingredient = await ingredientsDatabase.rawQuery(
      '''SELECT * FROM $tableName WHERE id = ?''', [id]
    );
    return Ingredient.fromSqfliteDatabase(ingredient.first);
 }

 static void createDatabase(){
    IngredientProvider provider = IngredientProvider();
    provider.create(name: "Cukier",
        harmfulness: Harmfulness.bad,
        description: "Cukier to nic fajnego",
        category: IngredientCategory.preservative);
    provider.create(name: "Cukier1",
        harmfulness: Harmfulness.bad,
        description: "Cukier to nic fajnego1",
        category: IngredientCategory.preservative);
    provider.create(name: "Cukier11",
        harmfulness: Harmfulness.bad,
        description: "Cukier to nic fajnego11",
        category: IngredientCategory.preservative);
    provider.create(name: "Cukier111",
        harmfulness: Harmfulness.bad,
        description: "Cukier to nic fajnego111",
        category: IngredientCategory.preservative);
    provider.create(name: "Cukier1111",
        harmfulness: Harmfulness.bad,
        description: "Cukier to nic fajnego1111",
        category: IngredientCategory.preservative);
 }
}