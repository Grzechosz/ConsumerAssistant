import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../databases/ingredients.dart';
import '../models/ingredient.dart';

class IngredientsScreen extends Column{

  late Container ingredientsListContainer;
  static final IngredientProvider ingredientProvider = IngredientProvider();
  static Future<List<Ingredient>>? ingredientsList;
  static int selectedSortOption = 0;
  static List<DropdownMenuItem<int>> get sortItems{
    List<DropdownMenuItem<int>> items = [
      DropdownMenuItem(child: Text('Nazwa A-Z'), value: 0),
      DropdownMenuItem(child: Text('Nazwa Z-A'), value: 1),
      DropdownMenuItem(child: Text('Szkodliwość'), value: 2),
      DropdownMenuItem(child: Text('Kategoria'), value: 3)
    ];
    return items;
  }

  static void initIngredientsList(){
    ingredientsList = ingredientProvider.fetchAll();
  }

  IngredientsScreen() : super(children: [
    _buildSearchBox(),
    _buildSortBy(),
    _buildIngredientsList()]){
    IngredientProvider.createDatabase();
  }

  static Widget _buildSearchBox(){
    return
      Container(
        margin: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white70),

        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextField(
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

  static Widget _buildSortBy(){
    return
      Container(
        margin: EdgeInsets.only(top: 5),
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white70),

        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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

  static Expanded _buildIngredientsList(){
    // print(ingredientsList.last == null ?? "XD");
    return Expanded(
      child: FutureBuilder<List<Ingredient>>(
        future: ingredientsList,
        builder: (BuildContext context, AsyncSnapshot<List<Ingredient>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final ingredients = snapshot.data!;
            return ingredients.isEmpty ?
              const Center(
                child: Text("Brak składników"),
              ) :
              ListView.separated(
                  itemBuilder: (context, index){
                    final ingredient = ingredients[index];
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
                  itemCount: ingredients.length);
              //   (
              //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              //   children: [
              //     IngredientItem(Ingredient(id: 1,
              //         name: 'XD',
              //         description: 'xdd',
              //         harmfulness: Harmfulness.bad,
              //         category: IngredientCategory.preservative)),
              //     IngredientItem(Ingredient(id: 2,
              //         name: 'XDD',
              //         description: 'xdd',
              //         harmfulness: Harmfulness.bad,
              //         category: IngredientCategory.preservative)),
              //     IngredientItem(Ingredient(id: 3,
              //         name: 'XDDD',
              //         description: 'xdd',
              //         harmfulness: Harmfulness.good,
              //         category: IngredientCategory.preservative)),
              //   ],
              // );


          }
        }
      )

    );
  }
}