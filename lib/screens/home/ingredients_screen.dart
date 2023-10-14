import 'package:flutter/material.dart';

import '../../databases/Ingredient_provider.dart';
import '../../models/ingredient.dart';

class IngredientsScreen extends StatelessWidget{

  late Container ingredientsListContainer;
  // static final IngredientProvider ingredientProvider = IngredientProvider();
  static Future<List<Ingredient>>? ingredientsList;
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
            color: Colors.white70),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.black26,),
                hintStyle: TextStyle(
                    color: Colors.black26,
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

  // static Expanded _buildIngredientsList(){

  Text _buildIngredientsList(){
    return const Text("dupa");

    // initIngredientsList();
    // return Expanded(
    //   child: FutureBuilder<List<Ingredient>>(
    //     future: ingredientsList,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(child: CircularProgressIndicator());
    //       } else {
    //         final ingredients = snapshot.data!;
    //
    //         return ingredients.isEmpty ?
    //           const Center(
    //             child: Text("Brak składników"),
    //           ) :
    //           ListView.separated(
    //               itemBuilder: (context, index){
    //                 final ingredient = ingredients[index];
    //                 return ListTile(
    //                   // title: IngredientItem(ingredient)
    //                 );
    //               },
    //               separatorBuilder: (context, index) =>
    //               const SizedBox(height: 12),
    //               itemCount: ingredients.length);
    //
    //       }
    //     }
    //   )
    //
    // );
  }
}