import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consciousconsumer/services/ingredients_service.dart';

import 'ingredient.dart';

class Product{
  final String id;
  final double rating;
  final String productName;
  final String productImageUrl;
  final String remarks;
  final List<Future<Ingredient>> ingredients;
  final DateTime createdDate;

  Product(this.productName, this.rating, this.productImageUrl, this.ingredients, this.createdDate, this.remarks, this.id);

  factory Product.fromFirebase(Map<String, dynamic> map, String uid) {
    IngredientsService service = IngredientsService();
    final String id;
    final String productName;
    final String productImageUrl;
    final String remarks;
    final List<Future<Ingredient>> ingredients = [];
    final double rating;  // value from range 0-1
    DateTime createdDate;

    id=uid;
    for(dynamic ingredientId in map['ingredients']){
      ingredients.add(service.getIngredientById(ingredientId.toString()));
    }
    productName = map['productName'] as String;
    productImageUrl = map['productImageUrl'] as String;
    remarks = map['remarks'] as String;
    rating = double.parse(map['rating'].toString());
    createdDate = (map['createdDate'] as Timestamp).toDate();

    return Product(productName, rating, productImageUrl, ingredients, createdDate, remarks, id);
  }

  Future<Map<String, dynamic>> toFirebase() async{
    List<String> list = [];
    for(Future<Ingredient> future in ingredients){
      list.add((await future).id.toString());
    }
    Map<String, dynamic> map = {
      'ingredients': list,
      'rating': rating,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'createdDate': Timestamp.now(),
      'remarks': remarks
    };
    return map;
  }
}