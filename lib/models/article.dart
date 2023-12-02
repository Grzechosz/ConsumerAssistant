class Article{
  final String id;
  final String title;
  final String body;
  final String author;
  final String imagePath;
  Article({required this.id, required this.title, required this.body, required this.author, required this.imagePath});

  factory Article.fromFirebase(Map<String, dynamic> map, String id) {
    final String title;
    final String body;
    final String author;
    final String imagePath;

    title = map['title'] as String;
    body = map['body'] as String;
    author = map['author'] as String;
    imagePath = map['imagePath'] as String;
    return Article(
        title: title,
        author: author,
        body: body,
        imagePath: imagePath,
        id: id);
  }
}