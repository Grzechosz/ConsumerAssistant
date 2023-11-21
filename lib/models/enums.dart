enum Harmfulness{
  good(1), harmful(2), dangerous(3), uncharted(4);
  const Harmfulness(this.id);
  final int id;
}

enum Category{
  color(1), preservative(2), antioxidant(3), emulsifier(4), enhancers(5),
  excipient(6), sweeteners(7), others(8), fruits(9), vegetables(10),
  nuts(11), sugars(12), loose(13), dairy(14), meats(15),
  herbsAndSpices(16), fishesAndSeafood(17), intermediates(18);
  const Category(this.id);
  final int id;
}

enum SortMethod{
  name, E, harmfulness, category;
}