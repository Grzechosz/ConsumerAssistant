import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/article.dart';

class ArticlesService{
  final CollectionReference ingredientCollection = FirebaseFirestore
      .instance.collection('articles');
  static bool isLoaded = false;

  Stream<List<Article>> get articles{
    isLoaded = false;
    return ingredientCollection
        .snapshots()
        .map(_articlesFromSnapshot);
  }

  List<Article> _articlesFromSnapshot(QuerySnapshot snapshot){
    List<Article> items = snapshot.docs.map(
            (e) => Article.fromFirebase(
            e.data() as Map<String, dynamic>,
            e.id)
    ).toList();
    isLoaded = true;
    return items;
  }

  Future<Article> getIngredientById(String id) async{
    DocumentSnapshot<Map<String, dynamic>> map =
    await FirebaseFirestore.instance.doc('articles/$id')
        .get();
    return Article.fromFirebase(map.data()!, id);
  }

}