import 'package:consciousconsumer/screens/ingredients/sorting_and_filtering.dart';
import 'package:consciousconsumer/services/ingredients_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../loading.dart';
import '../../models/ingredient.dart';
import 'ingredient_item.dart';

class IngredientsScreen extends StatefulWidget{
  const IngredientsScreen({super.key});
  @override
  State<StatefulWidget> createState() => IngredientsScreenState();
}

class IngredientsScreenState extends State<IngredientsScreen>{
  static int selectedSortOption = 0;
  String searchText = "";
  bool isDownwardArrow=true;

  late List allIngredients;
  late List ingredients;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Constants.sea80,
      child: Column(children: [
        _buildSearchBox(screenSize),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSortBy(screenSize),
            _buildSortDirection(screenSize),
          ],
        ),
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
              hintText: Constants.searchText,
              border: InputBorder.none
          )
      ),
    );
  }

  Widget _buildSortBy(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/100,
          bottom: screenSize.height/100),
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

  Widget _buildSortDirection(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/100,
          bottom: screenSize.height/100),
      height: screenSize.width/10,
      width: screenSize.width/10,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),

      child: IconButton(
        onPressed: () {
          setState(() {
            isDownwardArrow=!isDownwardArrow;
          });
        },
        icon: isDownwardArrow ? const Icon(
          Icons.arrow_downward,
          size: 20,) : const Icon(
          Icons.arrow_upward,
          size: 20,),
      ),
    );
  }

  StreamProvider _buildIngredients(){
    return StreamProvider<List<Ingredient>>.value(
        value: IngredientsService().ingredients,
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
    if(IngredientsService.isLoaded){
      ingredients = SortingAndFiltering.ingredientsFilter(searchText, allIngredients).toList();
      SortingAndFiltering.sort(selectedSortOption, ingredients, isDownwardArrow);
      return ListView.builder(
        padding: const EdgeInsets.only(top: 0),
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
      return const Loading(isReversedColor:false);
    }
  }
}