import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:flutter/material.dart';

import '../../../models/enums.dart';
import 'ingredient_description.dart';

class IngredientItem extends StatelessWidget{

  final Ingredient item;

  const IngredientItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: _getIconImage(screenSize),
        onTap: (){
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (q,w,e) =>
                  IngredientDescription(ingredient: item))
          );
        },
        shape: const Border(
            bottom: BorderSide(
                color: Constants.dark50
            ),
        ),
        title: Text(_getNameToDisplay()),
        subtitle: Text(_getTrailing(),
            style: const TextStyle(
                color: Constants.dark50,
                fontSize: 15
            )),
      )
    );
  }

  String _getNameToDisplay(){
    String name = "";
    bool eIngredient = item.names[0].substring(0, 1) == 'E' ? false : true;
    bool flag = eIngredient;
    for (var element in item.names) {
      if(flag) {
        name = "$name$element, ";
      }
      flag = true;
    }
    name = name.substring(0, name.length-2);
    name = eIngredient ?  name : "$name (${item.names[0]})";
    name = name.firstLetterUpper();
    return name;
  }

  Image _getIconImage(Size screenSize){
    String icon;
    switch(item.harmfulness){
      case Harmfulness.good:
        icon = Constants.ASSETS_HARMFULNESS_ICONS + Constants.GOOD_ICON;
        break;
      case Harmfulness.harmful:
        icon = Constants.ASSETS_HARMFULNESS_ICONS + Constants.HARMFUL_ICON;
        break;
      case Harmfulness.dangerous:
        icon = Constants.ASSETS_HARMFULNESS_ICONS + Constants.DANGEROUS_ICON;
        break;
      case Harmfulness.uncharted:
        icon = Constants.ASSETS_HARMFULNESS_ICONS + Constants.UNCHARTED_ICON;
        break;
    }
    return Image.asset(icon, height: screenSize.height/20,);
  }
  String _getTrailing(){
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
}

extension StringExtension on String {
  String firstLetterUpper() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}