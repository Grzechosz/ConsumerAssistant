import 'package:consciousconsumer/screens/home/account_screen.dart';
import 'package:consciousconsumer/screens/home/ingredients_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'home/Scanner.dart';

class ConsciousConsumer extends StatefulWidget{
  final CameraDescription camera;

  const ConsciousConsumer({super.key, required this.camera});

  @override
  State<ConsciousConsumer> createState()=>
      _ConsciousConsumerState();
}

class _ConsciousConsumerState extends State<ConsciousConsumer> {
  int _selectedIndex = 0;

  final List<Widget> _widgets = [
    const Text("Last", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.amber),),
    IngredientsScreen(),
    const Text("Scanner", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black ),),
    const Text("Excluded", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.red),),
    AccountScreen(),
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Center(
          child: _selectedIndex == 2
          ? ScannerScreen(camera: widget.camera) : _widgets[_selectedIndex],//_widgets[_selectedIndex],
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