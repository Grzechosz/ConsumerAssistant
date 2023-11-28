import 'dart:core';

import '../../models/product.dart';

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

  static void productsSorting(List products){
    products.sort((prodA, prodB){
      return prodA.createdDate.isBefore(prodB.createdDate) ? 1 : -1;
    });
  }

  static void sort(int sortOption, List ingredients, bool sortDown){
    switch(sortOption){
      case 0:
        ingredients.sort((ing1, ing2){
          String name01 = ing1.names[0], name02 = ing2.names[0];
          if(name01.substring(0,1)=='E' && name02.substring(0,1)=='E'){
            return sortDown ? ing1.names[1].compareTo(ing2.names[1]) : ing2.names[1].compareTo(ing1.names[1]);
          }else{
            return 1;
          }
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
          (ing1Int>ing2Int ? (sortDown?1:-1) : (sortDown?-1:1));
        });
        break;
      case 2:
        ingredients.sort((ing1, ing2){
          return ing1.harmfulness.id > ing2.harmfulness.id ? (sortDown?1:-1) : (sortDown?-1:1);
        });
        break;
      case 3:
        ingredients.sort((ing1, ing2){
          return ing1.category.id > ing2.category.id ? (sortDown?1:-1) : (sortDown?-1:1);
        });
        break;
    }
  }
}