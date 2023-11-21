import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';

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
}