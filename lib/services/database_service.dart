import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';

class DatabaseService{
  final CollectionReference ingredientCollection = FirebaseFirestore.instance.collection('ingredients');

  Stream<List<Ingredient>> get ingredients{
    return ingredientCollection.snapshots()
    .map(_ingredientsFromSnapchot);
  }

  List<Ingredient> _ingredientsFromSnapchot(QuerySnapshot snapshot){
    return snapshot.docs.map(
            (e) => Ingredient.fromFirebase(
                e.data() as Map<String, dynamic>,
                int.parse(e.id))
    ).toList();
  }
}