import 'package:cloud_firestore/cloud_firestore.dart';

class Article{
  final String id;
  final String title;
  final String body;
  final String author;
  final String imagePath;
  final DateTime date;
  Article({required this.id, required this.title, required this.body, required this.author, required this.imagePath, required this.date});

  factory Article.fromFirebase(Map<String, dynamic> map, String id) {
    final String title;
    final String body;
    final String author;
    final String imagePath;
    final DateTime date;

    title = map['title'] as String;
    body = map['body'] as String;
    author = map['author'] as String;
    imagePath = map['imagePath'] as String;
    date = (map['date'] as Timestamp).toDate();

    return Article(
        title: title,
        author: author,
        body: body,
        imagePath: imagePath,
        id: id,
        date: date);
  }
}