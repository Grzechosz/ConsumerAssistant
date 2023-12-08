import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:consciousconsumer/models/models.dart';

class ProductsService{
  CollectionReference? productCollection;
  static bool isLoaded = false;

  ProductsService({required userId}){
    productCollection = productCollection = FirebaseFirestore
        .instance.collection('users_data').doc(userId).collection('products');
  }

  Stream<List<Product>> get products{
    isLoaded = false;
    return productCollection!
        .snapshots()
        .map(_productsFromSnapshot);
  }

  List<Product> _productsFromSnapshot(QuerySnapshot snapshot){
    List<Product> items = snapshot.docs.map(
            (e) => Product.fromFirebase(
            e.data() as Map<String, dynamic>,
            e.id)
    ).toList();
    isLoaded = true;
    return items;
  }

  // upload product to firebase
  Future uploadProduct(Product product, XFile image) async {
    productCollection!
        .doc(product.id.toString())
        .set(await product.toFirebase())
        .onError((error, stackTrace) =>
            print("Error writing document: $error"));
    final storageService = StorageService();
    storageService.uploadProductImage(image);
  }

  // delete product from firebase
  Future deleteProduct(Product product) async {
    StorageService().deleteProductImage(product);
    await productCollection!.doc(product.id.toString())
        .delete().then((value) => print("Document deleted"));
  }

  // delete all products of user
  Future clearProducts(String userId) async {
    StorageService storageService = StorageService();
    storageService.deleteUserFolder(userId);
    List<List<Product>> tmp = await products.toList();
    for(List<Product> list in tmp){
      for(Product product in list){
        deleteProduct(product);
      }
    }
  }

  // update product in firebase
}