import 'package:consciousconsumer/models/ingredient.dart';
import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget{

  final Ingredient item;

  const IngredientItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: (){
          // description
        },
        trailing: Text(item.category.name,
        style: const TextStyle(
            color: Colors.black38
        ),),
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black26
          )
        ),
        title: Text("none"),
      ),
    );
  }

}