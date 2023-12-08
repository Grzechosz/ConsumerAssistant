import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:consciousconsumer/models/models.dart';

class StorageService{

  Reference get firebaseStorage => FirebaseStorage.instance.ref();

  // download product image from firebase storage
  Future<String> getProductImage(Product product) {
    return firebaseStorage
      .child("products/${FirebaseAuth.instance.currentUser!.uid}")
      .child(product.productImageUrl)
    .getDownloadURL();
  }

  // download article image from firebase storage
  Future<String> getArticleImage(Article article) {
    return firebaseStorage
        .child("articles/")
        .child(article.imagePath)
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

  Future deleteUserFolder(String userId) async {
    List<String> paths = [];
    paths = await _deleteFolder("products/${FirebaseAuth.instance.currentUser!.uid}", paths);
    for (String path in paths) {
      await firebaseStorage.child(path).delete();
    }
  }

  Future<List<String>> _deleteFolder(String folder, List<String> paths) async {
    ListResult list = await firebaseStorage.child(folder).listAll();
    List<Reference> items = list.items;
    List<Reference> prefixes = list.prefixes;
    for (Reference item in items) {
      paths.add(item.fullPath);
    }
    for (Reference subfolder in prefixes) {
      paths = await _deleteFolder(subfolder.fullPath, paths);
    }
    return paths;
  }

  // delete product image from firebase storage
  void deleteProductImage(Product product){
    firebaseStorage
        .child("products/${FirebaseAuth.instance.currentUser!.uid}")
        .child(product.productImageUrl)
        .delete();
  }
}