import 'package:consciousconsumer/screens/ingredients/sorting_and_filtering.dart';
import 'package:consciousconsumer/services/ingredients_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/screens/loading.dart';
import '../../models/ingredient.dart';
import '../../models/enums.dart' as enums;
import 'ingredient_item.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});
  @override
  State<StatefulWidget> createState() => IngredientsScreenState();
}

class IngredientsScreenState extends State<IngredientsScreen> {
  static int selectedSortOption = 0;
  String searchText = "";
  bool isDownwardArrow = true;

  late List allIngredients;
  late List ingredients;
  enums.Category? checkedCategory;

  final List _categoriesList = [
    'wszystkie',
    'barwniki',
    'konserwanty',
    'przeciwutleniacze',
    'emulgatory',
    'wzmacniacze',
    'środki pomocnicze',
    'słodziki',
    'pozostałe dodatki',
    'owoce',
    'warzywa',
    'orzechy',
    'cukry',
    'sypkie',
    'nabiał',
    'mięsa',
    'zioła i przyprawy',
    'ryby i owoce morza',
    'półprodukty'
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Constants.sea80,
      child: Column(children: [
        _buildSearchBox(screenSize),
        _buildCategoriesList(screenSize),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSortBy(screenSize),
            _buildSortDirection(screenSize),
          ],
        ),
        _buildIngredients(screenSize)
      ]),
    );
  }

  static List<DropdownMenuItem<int>> get sortItems {
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem(
          value: 0,
          child: Text(
            'Nazwa',
            style: TextStyle(
                color: Constants.dark80, fontSize: Constants.headerSize),
          )),
      // const DropdownMenuItem(value: 1, child: Text('Oznaczenie E')),
      const DropdownMenuItem(
          value: 2,
          child: Text(
            'Szkodliwość',
            style: TextStyle(
                color: Constants.dark80, fontSize: Constants.headerSize),
          )),
      const DropdownMenuItem(
          value: 3,
          child: Text(
            'Kategoria',
            style: TextStyle(
                color: Constants.dark80, fontSize: Constants.headerSize),
          ))
    ];
    return items;
  }

  Widget _buildSearchBox(Size screenSize) {
    return Container(
      margin: EdgeInsets.only(
          top: screenSize.height / 20,
          left: screenSize.width / 100,
          right: screenSize.width / 100,
          bottom: screenSize.height / 250),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
          onChanged: (text) => setState(() {
                searchText = text;
              }),
          decoration: const InputDecoration(
              icon: Icon(
                Icons.search,
                size: 30,
                color: Constants.dark80,
              ),
              hintStyle: TextStyle(
                  color: Constants.dark50, fontSize: Constants.headerSize),
              hintText: Constants.searchText,
              border: InputBorder.none)),
    );
  }

  Widget _buildSortBy(Size screenSize) {
    return Container(
      margin: EdgeInsets.only(
          bottom: screenSize.height / 150, right: screenSize.width / 100),
      height: screenSize.width / 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
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

  Widget _buildSortDirection(Size screenSize) {
    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height / 150),
      height: screenSize.width / 10,
      width: screenSize.width / 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: IconButton(
        onPressed: () {
          setState(() {
            isDownwardArrow = !isDownwardArrow;
          });
        },
        icon: isDownwardArrow
            ? const Icon(
                Icons.arrow_downward,
                size: 20,
                color: Constants.dark80,
              )
            : const Icon(Icons.arrow_upward, size: 20, color: Constants.dark80),
      ),
    );
  }

  Widget _buildIngredients(Size screenSize) {
    return FirebaseAuth.instance.currentUser!.emailVerified
        ? StreamProvider<List<Ingredient>>.value(
            value: IngredientsService().ingredients,
            initialData: const [],
            builder: (context, child) {
              return Expanded(
                child: _buildIngredientsList(context),
              );
            },
          )
        : Expanded(
            child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.transparent
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            margin: EdgeInsets.symmetric(
                horizontal: screenSize.width / 20,
                vertical: screenSize.height / 5),
            alignment: Alignment.center,
            child: const Text(
              'Zweryfikuj email aby korzystać z aplikacji!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: Constants.bigHeaderSize,
                  fontWeight: FontWeight.w600),
            ),
          ));
  }

  Widget _buildIngredientsList(BuildContext context) {
    allIngredients = Provider.of<List<Ingredient>>(context);
    if (IngredientsService.isLoaded) {
      ingredients =
          SortingAndFiltering.ingredientsFilter(searchText, allIngredients)
              .toList();
      SortingAndFiltering.sort(
          selectedSortOption, ingredients, isDownwardArrow);
      ingredients = SortingAndFiltering.ingredientsFromCategory(
              checkedCategory, ingredients)
          .toList();
      return ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return (ingredients.isEmpty
              ? const Center(
                  child: Text(
                    "Brak składników",
                    style: TextStyle(fontSize: Constants.theBiggestSize),
                  ),
                )
              : IngredientItem(ingredients[index], false));
        },
      );
    } else {
      return const Loading(isReversedColor: false);
    }
  }

  Widget _buildCategoriesList(Size screenSize) {
    return Container(
      height: screenSize.height / 5.2,
      margin: const EdgeInsets.only(bottom: 5),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _categoriesList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              width: screenSize.width / 2.5,
              child: Card(
                color: Colors.white,
                child: ListTile(
                  onTap: () {
                    setState(() {
                      checkedCategory = index - 1 >= 0
                          ? enums.Category.values.elementAt(index - 1)
                          : null;
                    });
                  },
                  title: Text(
                    (_categoriesList[index] as String)[0].toUpperCase() +
                        (_categoriesList[index] as String).substring(1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: Constants.headerSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Image.asset(
                    "${Constants.assetsCategoriesIcons}"
                    "${index - 1 >= 0 ? enums.Category.values.elementAt(index - 1).name : "all"}"
                    ".png",
                  ),
                ),
              ),
            );
          }),
    );
  }
}
