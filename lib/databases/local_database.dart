// import 'package:consciousconsumer/databases/Ingredient_provider.dart';
// import 'package:path/path.dart';
//
// class LocalDatabase{
//   static final LocalDatabase _localDatabase = LocalDatabase._constructor();
//
//   factory LocalDatabase(){
//     return _localDatabase;
//   }
//
//   final _databaseName = "consumer_assistant.db";
//   final _databaseVersion = 1;
//   Database? _database;
//
//   LocalDatabase._constructor();
//
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await _init();
//     return _database!;
//   }
//
//   Future<String> get fullPath async {
//     return join(await getDatabasesPath(),
//         _databaseName);
//   }
//
//   Future<Database> _init() async {
//     var database = await openDatabase(
//         await fullPath,
//         version: _databaseVersion,
//         onCreate: _onCreate,
//         singleInstance: true
//     );
//     return database;
//   }
//
//   Future _onCreate(Database db, int version) async{
//     await IngredientProvider().createTable(db);
//   }
// }