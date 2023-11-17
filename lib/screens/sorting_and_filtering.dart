
import 'dart:core';


class SortingAndFiltering{
  static Iterable ingredientsFilter(String pattern, List<dynamic> all){
    return all.where((element) {
      if(pattern==""){
        return true;
      }
      bool check = false;
      for(String name in element.names){
        check = name.toLowerCase().contains(
            RegExp(pattern.toLowerCase())
        );
        if(check){
          return true;
        }
      }
      return check;
    });
  }

  static Iterable productsFilter(String pattern, List<dynamic> all){
    return all.where((element) {
      if(pattern==""){
        return true;
      }
      return element.productName.toLowerCase().contains(RegExp(pattern.toLowerCase()));
      });
  }

  static void sort(int sortOption, List ingredients, bool downerSort){
    switch(sortOption){
      case 0:
        ingredients.sort((ing1, ing2){
          return downerSort ? ing1.names[1].compareTo(ing2.names[1]) : ing2.names[1].compareTo(ing1.names[1]);
        });
        break;
      case 1:
        ingredients.sort((ing1, ing2){
          String nameE1 = ing1.names[0], nameE2 = ing2.names[0];
          int ing1Int, ing2Int;
          try {
            ing1Int = int.parse(nameE1.substring(1));
          } on FormatException {
            ing1Int = int.parse(nameE1.substring(1, nameE1.length-1));
          }
          try {
            ing2Int = int.parse(nameE2.substring(1));
          } on FormatException {
            ing2Int = int.parse(nameE2.substring(1, nameE2.length-1));
          }
          return ing1Int==ing2Int ?
          (nameE1.substring(nameE1.length-1).compareTo(nameE2.substring(nameE2.length-1))) :
          (ing1Int>ing2Int ? (downerSort?1:-1) : (downerSort?-1:1));
        });
        break;
      case 2:
        ingredients.sort((ing1, ing2){
          return ing1.harmfulness.id > ing2.harmfulness.id ? (downerSort?1:-1) : (downerSort?-1:1);
        });
        break;
      case 3:
        ingredients.sort((ing1, ing2){
          return ing1.category.id > ing2.category.id ? (downerSort?1:-1) : (downerSort?-1:1);
        });
        break;
    }
  }
}