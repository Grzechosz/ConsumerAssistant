import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/screens/widgets/ingredients_list.dart';
import 'package:consciousconsumer/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import '../widgets/ingredient_item.dart';

class IngredientsScreen extends StatelessWidget{

  late Container ingredientsListContainer;
  static int selectedSortOption = 0;

  IngredientsScreen({super.key});
  static List<DropdownMenuItem<int>> get sortItems{
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem(value: 0, child: Text('Nazwa A-Z')),
      const DropdownMenuItem(value: 1, child: Text('Nazwa Z-A')),
      const DropdownMenuItem(value: 2, child: Text('Szkodliwość')),
      const DropdownMenuItem(value: 3, child: Text('Kategoria'))
    ];
    return items;
  }

  // static void initIngredientsList(){
  //   ingredientsList = ingredientProvider.fetchAll();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildSearchBox(),
      _buildSortBy(),
      _buildIngredientsList()
    ]);
  }

  Widget _buildSearchBox(){
    return
      Container(
        margin: const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Constants.dark50,),
                hintStyle: TextStyle(
                    color: Constants.dark50,
                    fontSize: 20
                ),
                hintText: 'Search',
                border: InputBorder.none
            )
        ),
      );
  }

  Widget _buildSortBy(){
    return
      Container(
        margin: const EdgeInsets.only(top: 5),
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white70),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: DropdownButton(
          value: selectedSortOption,
          items: sortItems,
          onChanged: (int? value) {
            selectedSortOption = value!;
            selectedSortOption = value;
          },
        ),
      );
  }

  StreamProvider _buildIngredientsList(){
    return StreamProvider<List<Ingredient>>.value(
      value: DatabaseService().ingredients,
      initialData: const [],
      child: const Expanded(
        child: IngredientsList(),
      )
    );
  }
}