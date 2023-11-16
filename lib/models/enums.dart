enum Harmfulness{
  good(1), harmful(2), dangerous(3), uncharted(4);
  const Harmfulness(this.id);
  final int id;
}

enum Category{
  color(1), preservative(2), antioxidant(3), emulsifier(4), enhancers(5), excipient(6), sweeteners(7), others(8);
  const Category(this.id);
  final int id;
}

enum SortMethod{
  name, E, harmfulness, category;
}