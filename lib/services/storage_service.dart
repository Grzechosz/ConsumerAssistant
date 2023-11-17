
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/product.dart';

class StorageService{

  Reference get firebaseStorage => FirebaseStorage.instance.ref();

  // download product image from firebase storage
  Future<String> getProductImage(Product product) {
    return firebaseStorage
      .child("products/${FirebaseAuth.instance.currentUser!.uid}")
      .child(product.productImageUrl)
    .getDownloadURL();
  }

  // upload product image to firebase storage

  // delete product image from firebase storage
}