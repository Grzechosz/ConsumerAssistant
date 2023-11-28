
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

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
  Future uploadProductImage(XFile image) async {
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final uploadFile = File(image.path);
    final uploadTask = firebaseStorage
        .child("products/${FirebaseAuth.instance.currentUser!.uid}")
        .child(image.name)
        .putFile(uploadFile, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads
          break;
        case TaskState.success:
        // Handle successful uploads on complete
        // ...
          break;
      }
    });

  }

  // delete product image from firebase storage
  void deleteProductImage(Product product){
    firebaseStorage
        .child("products/${FirebaseAuth.instance.currentUser!.uid}")
        .child(product.productImageUrl)
        .delete();
  }
}