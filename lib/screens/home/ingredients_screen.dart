import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/screens/sorting_and_filtering.dart';
import 'package:consciousconsumer/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../loading.dart';
import '../../models/ingredient.dart';
import '../widgets/ingredients_screen/ingredient_item.dart';

class IngredientsScreen extends StatefulWidget{
  const IngredientsScreen({super.key});
  @override
  State<StatefulWidget> createState() => IngredientsScreenState();
}

class IngredientsScreenState extends State<IngredientsScreen>{
  late Container ingredientsListContainer;
  static int selectedSortOption = 0;
  String searchText = "";

  late List allIngredients;
  late List ingredients;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Constants.sea80,
      child: Column(children: [
        _buildSearchBox(screenSize),
        _buildSortBy(screenSize),
        _buildIngredients()
      ]),
    );
  }

  static List<DropdownMenuItem<int>> get sortItems{
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem(value: 0, child: Text('Nazwa')),
      const DropdownMenuItem(value: 1, child: Text('Oznaczenie E')),
      const DropdownMenuItem(value: 2, child: Text('Szkodliwość')),
      const DropdownMenuItem(value: 3, child: Text('Kategoria'))
    ];
    return items;
  }

  Widget _buildSearchBox(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/20, left: screenSize.width/40, right: screenSize.width/40),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(25),
          color: Colors.white),

      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
          onChanged: (text)=>setState(() {
            searchText = text;
          }),
          decoration: const InputDecoration(
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

  Widget _buildSortBy(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/100),
      height: screenSize.width/10,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),

      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: DropdownButton(
        value: selectedSortOption,
        items: sortItems,
        onChanged: (int? value) {
          setState(() {
            selectedSortOption = value!;
          });
        },
      ),
    );
  }

  StreamProvider _buildIngredients(){
    return StreamProvider<List<Ingredient>>.value(
        value: DatabaseService().ingredients,
        initialData: const [],
        builder: (context, child) {
          return Expanded(
            child: _buildIngredientsList(context),
          );
        },
    );
  }

  Widget _buildIngredientsList(BuildContext context){
    allIngredients = Provider.of<List<Ingredient>>(context);
    if(DatabaseService.isLoaded){
      ingredients = SortingAndFiltering.filter(searchText, allIngredients).toList();
      SortingAndFiltering.sort(selectedSortOption, ingredients);
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ingredients.length,
        itemBuilder:(context, index) {
          return (ingredients.isEmpty ?
          const Center(
            child: Text("Brak składników"),
          ) :
          ListTile(title: IngredientItem(ingredients[index])));
        },
      );
    }else{
      return const Loading();
    }
  }
}