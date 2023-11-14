import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';

class DatabaseService{
  final CollectionReference ingredientCollection = FirebaseFirestore
      .instance.collection('ingredients');
  static bool isLoaded = false;

  Stream<List<Ingredient>> get ingredients{
    isLoaded = false;
    return ingredientCollection
        .orderBy('names')
        .snapshots()
    .map(_ingredientsFromSnapchot);
  }

  List<Ingredient> _ingredientsFromSnapchot(QuerySnapshot snapshot){
    List<Ingredient> items = snapshot.docs.map(
            (e) => Ingredient.fromFirebase(
            e.data() as Map<String, dynamic>,
            int.parse(e.id))
    ).toList();
    isLoaded = true;

    return items;
  }
}