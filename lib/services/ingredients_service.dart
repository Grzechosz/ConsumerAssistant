import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consciousconsumer/models/models.dart';

class IngredientsService{
  final CollectionReference ingredientCollection = FirebaseFirestore
      .instance.collection('ingredients');
  static bool isLoaded = false;

  Stream<List<Ingredient>> get ingredients{
    isLoaded = false;
    return ingredientCollection
        .orderBy('names')
        .snapshots()
    .map(_ingredientsFromSnapshot);
  }

  List<Ingredient> _ingredientsFromSnapshot(QuerySnapshot snapshot){
    List<Ingredient> items = snapshot.docs.map(
            (e) => Ingredient.fromFirebase(
            e.data() as Map<String, dynamic>,
            int.parse(e.id))
    ).toList();
    isLoaded = true;
    return items;
  }

  Future<Ingredient> getIngredientById(String id) async{
    DocumentSnapshot<Map<String, dynamic>> map =
      await FirebaseFirestore.instance.doc('ingredients/$id')
      .get();
    return Ingredient.fromFirebase(map.data()!, int.parse(id));
  }

  Future<Ingredient?> getIngredientByName(String nameFromLabel) async{
    Future<QuerySnapshot<Object?>> map = ingredientCollection
        .where("names", arrayContains: nameFromLabel)
        .get();

      Ingredient? result = (await map).docs.map(
              (e) => Ingredient.fromFirebase(
              e.data() as Map<String, dynamic>,
              int.parse(e.id))).firstOrNull;
      return result;
  }
}