import 'package:consciousconsumer/databases/ingredients.dart';
import 'package:consciousconsumer/enums.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:consciousconsumer/widgets/ingredientItem.dart';
import 'package:flutter/material.dart';

class ConsciousConsumer extends StatefulWidget{
  const ConsciousConsumer({super.key});

  @override
  State<ConsciousConsumer> createState()=>
      _ConsciousConsumerState();
}

class _ConsciousConsumerState extends State<ConsciousConsumer> {
  int _selectedIndex = 0;
  late Container ingredientsListContainer;

  late List<Ingredient> ingredientsList;
  
  int selectedSortOption = 0;

  _ConsciousConsumerState(){
    IngredientProvider().fetchAll().then((list) => ingredientsList = list);
  }
  
  List<DropdownMenuItem<int>> get sortItems{
    List<DropdownMenuItem<int>> items = [
      DropdownMenuItem(child: Text('Nazwa A-Z'), value: 0),
      DropdownMenuItem(child: Text('Nazwa Z-A'), value: 1),
      DropdownMenuItem(child: Text('Szkodliwość'), value: 2),
      DropdownMenuItem(child: Text('Kategoria'), value: 3)
    ];
    return items;
  }
  
  List<Widget> _widgets = [
    Text("Last", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.amber),),
    Column(),
    Text("Scanner", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black ),),
    Text("Excluded", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.red),),
    Text("Account", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.green ),),
  ];

  Column _buildIngredientsScreen(){
    return Column(
      children: [
        _buildSearchBox(),
        _buildSortBy(),
        _buildIngredientsList()
      ],
    );
  }

  Widget _buildSearchBox(){
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

  Widget _buildSortBy(){
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
            this._selectedIndex = value!;
            selectedSortOption = value;
          },
        ),
      );
  }

  Expanded _buildIngredientsList(){
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        children: [
          IngredientItem(Ingredient(id: 1, name: 'XD', description: 'xdd', harmfulness: Harmfulness.bad, category: IngredientCategory.preservative)),
          IngredientItem(Ingredient(id: 2, name: 'XDD', description: 'xdd', harmfulness: Harmfulness.bad, category: IngredientCategory.preservative)),
          IngredientItem(Ingredient(id: 3, name: 'XDDD', description: 'xdd', harmfulness: Harmfulness.good, category: IngredientCategory.preservative)),
          // for(Ingredient ingredient in ingredientsList)
          //   IngredientItem(ingredient)

        ],
      ),
    ) ;
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgets[1] = _buildIngredientsScreen();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Conscious Consumer"),
      // ),
      body: Container(
        child: Center(
          child: _widgets[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Last",
            icon: Icon(
              Icons.history,
              color: Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "Book",
            icon: Icon(
              Icons.menu_book_rounded,
              color: Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "Scanner",
            icon: Icon(
              Icons.document_scanner,
              color: Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "Excluded",
            icon: Icon(
              Icons.menu_book_rounded,
              color: Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "Account",
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.grey,
            ),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}