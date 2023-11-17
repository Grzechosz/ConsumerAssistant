import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductsService{
  Query<Map<String, dynamic>> productCollection = FirebaseFirestore
      .instance.collection('products');
  static bool isLoaded = false;

  ProductsService({required userId}){
    productCollection = productCollection.where('userId', isEqualTo: userId);
  }

  Stream<List<Product>> get products{
    isLoaded = false;
    return productCollection
        .snapshots()
        .map(_productsFromSnapchot);
  }

  List<Product> _productsFromSnapchot(QuerySnapshot snapshot){
    List<Product> items = snapshot.docs.map(
            (e) => Product.fromFirebase(
            e.data() as Map<String, dynamic>,
            int.parse(e.id))
    ).toList();
    isLoaded = true;
    return items;
  }

  // delete product from firebase

  // update product in firebase
}