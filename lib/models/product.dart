import 'ingredient.dart';

class Product{
  final double rating;
  final String imageUrl;
  final List<Ingredient> ingredients;

  Product(this.rating, this.imageUrl, this.ingredients);
}