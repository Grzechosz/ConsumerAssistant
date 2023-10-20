import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget{

  final Ingredient item;

  const IngredientItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        // description
      },
      trailing: Text(item.category.name,
      style: const TextStyle(
          color: Constants.dark50
      ),),
      shape: const Border(
        bottom: BorderSide(
          color: Constants.dark50
        )
      ),
      title: Text(item.names[0])
    );
  }

}