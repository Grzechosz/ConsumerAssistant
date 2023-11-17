import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consciousconsumer/services/ingredients_service.dart';

import 'ingredient.dart';

class Product{
  final int id;
  final double rating;
  final String productName;
  final String productImageUrl;
  final String remarks;
  final List<Future<Ingredient>> ingredients;
  final DateTime createdDate;

  Product(this.productName, this.rating, this.productImageUrl, this.ingredients, this.createdDate, this.remarks, this.id);

  factory Product.fromFirebase(Map<String, dynamic> map, int uid) {
    IngredientsService service = IngredientsService();
    final int id;
    final String productName;
    final String productImageUrl;
    final String remarks;
    final List<Future<Ingredient>> ingredients = [];
    final double rating;
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
}