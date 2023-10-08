import 'package:camera/camera.dart';
import 'package:consciousconsumer/Scanner.dart';
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
  Text("Book", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.blueAccent),),
  Text("Scanner", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black ),),
  Text("Excluded", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.red),),
  Text("Account", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.green ),),


];

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: last',
      style: optionStyle,
    ),
    Text(
      'Index 1: book',
      style: optionStyle,
    ),
    Text(
      'Index 2: scanner',
      style: optionStyle,
    ),
    Text(
      'Index 3: excluded',
      style: optionStyle,
    ),
    Text(
      'Index 4: Account',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conscious Consumer"),
      ),
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