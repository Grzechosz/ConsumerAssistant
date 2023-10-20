import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import 'ingredient_item.dart';

class IngredientsList extends StatefulWidget{
  const IngredientsList({super.key});

  @override
  State<StatefulWidget> createState() => _IngredientsListState();

}

class _IngredientsListState extends State<IngredientsList>{

  @override
  Widget build(BuildContext context) {

    final ingredients = Provider.of<List<Ingredient>>(context);

    return
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: ingredients.length,
          itemBuilder:(context, index) {
            return (ingredients.isEmpty ?
                    const Center(
                      child: Text("Brak składników"),
                    ) :
                    ListTile(title: IngredientItem(ingredients[index])));
          }
      );
  }

}