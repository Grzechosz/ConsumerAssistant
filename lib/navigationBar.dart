import 'package:consciousconsumer/databases/ingredients.dart';
import 'package:consciousconsumer/enums.dart';
import 'package:consciousconsumer/models/ingredient.dart';
import 'package:consciousconsumer/screens/ingredientsScreen.dart';
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

  List<Widget> _widgets = [
    Text("Last", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.amber),),
    IngredientsScreen(),
    Text("Scanner", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black ),),
    Text("Excluded", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.red),),
    Text("Account", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.green ),),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      IngredientsScreen.initIngredientsList();
    });
  }

  @override
  Widget build(BuildContext context) {
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