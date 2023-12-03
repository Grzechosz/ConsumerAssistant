import 'package:consciousconsumer/models/ingredient.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../models/enums.dart';
import 'ingredient_description.dart';

class IngredientItem extends StatelessWidget{

  final Ingredient item;
  final bool isForProduct;

  const IngredientItem(this.item,  this.isForProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Card(
        shape: isForProduct ? RoundedRectangleBorder(
          side: const BorderSide(color: Constants.dark50, width: 1),
          borderRadius: BorderRadius.circular(10),
        ) : null,
      margin: EdgeInsets.symmetric(horizontal: screenSize.width/40,
          vertical: screenSize.height/150),
      color: Colors.white,
      child: ListTile(
        leading: getHarmfulnessIconImage(screenSize, item),
        onTap: () => pushIngredientDescription(context),
        title: Text(getNameToDisplay(item),
          style: const TextStyle(
            fontSize: Constants.titleSize,
          ),)
        ,
        subtitle: Text(getCategoryName(item),
            style: const TextStyle(
                color: Constants.dark50,
                fontSize: Constants.subTitleSize
            )),
      )
    );
  }

  static String getNameToDisplay(Ingredient ingredient){
    String name = "";
    bool eIngredient = ingredient.names[0].substring(0, 1) == 'E' ? false : true;
    bool flag = eIngredient;
    for (var element in ingredient.names) {
      if(flag) {
        name = "$name$element, ";
      }
      flag = true;
    }
    name = name.substring(0, name.length-2);
    name = eIngredient ?  name : "$name (${ingredient.names[0]})";
    name = name.firstLetterUpper();
    return name;
  }

  static Image getHarmfulnessIconImage(Size screenSize, Ingredient item){
    String icon;
    switch(item.harmfulness){
      case Harmfulness.good:
        icon = Constants.assetsHarmfulnessIcons + Constants.goodIcon;
        break;
      case Harmfulness.harmful:
        icon = Constants.assetsHarmfulnessIcons + Constants.harmfulIcon;
        break;
      case Harmfulness.dangerous:
        icon = Constants.assetsHarmfulnessIcons + Constants.dangerousIcon;
        break;
      case Harmfulness.uncharted:
        icon = Constants.assetsHarmfulnessIcons + Constants.unchartedIcon;
        break;
    }
    return Image.asset(icon, height: screenSize.height/20,);
  }

  static String getCategoryName(Ingredient item){
    String visibleCategory;
    switch(item.category){
      case Category.color:
        visibleCategory = "barwniki";
        break;
      case Category.preservative:
        visibleCategory = "konserwanty";
        break;
      case Category.antioxidant:
        visibleCategory = "przeciwutleniacze i regulatory kwasowości";
        break;
      case Category.emulsifier:
        visibleCategory = "emulgatory, środki spulchniające, żelujące itp.";
        break;
      case Category.enhancers:
        visibleCategory = "środki pomocnicze";
        break;
      case Category.excipient:
        visibleCategory = "wzmacniacze smaku";
        break;
      case Category.sweeteners:
        visibleCategory = "środki słodzące, nabłyszczające i inne";
        break;
      case Category.others:
        visibleCategory = "stabilizatory, konserwanty, zagęstniki i inne";
        break;
      case Category.fruits:
        visibleCategory = "owoce";
        break;
      case Category.vegetables:
        visibleCategory = "warzywa";
        break;
      case Category.nuts:
        visibleCategory = "orzechy";
        break;
      case Category.sugars:
        visibleCategory = "cukry";
        break;
      case Category.loose:
        visibleCategory = "produkty sypkie";
        break;
      case Category.dairy:
        visibleCategory = "nabiał";
        break;
      case Category.meats:
        visibleCategory = "mięso";
        break;
      case Category.herbsAndSpices:
        visibleCategory = "zioła i przyprawy";
        break;
      case Category.fishesAndSeafood:
        visibleCategory = "ryby i owoce morza";
        break;
      case Category.intermediates:
        visibleCategory = "półprodukty";
        break;
    }
    return visibleCategory;
  }

  void pushIngredientDescription(BuildContext context) {
    Navigator.push(context,
        PageRouteBuilder(pageBuilder: (q,w,e) => IngredientDescription(ingredient: item),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                SlideTransition(
                  position: Tween(
                    begin: const Offset(0.0, -1.0),
                    end: const Offset(0.0, 0.0),)
                      .animate(animation),
                  child: child,
                ))
    );
  }

}

extension StringExtension on String {
  String firstLetterUpper() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}