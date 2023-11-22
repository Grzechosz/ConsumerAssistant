import 'package:consciousconsumer/screens/home/account_screen.dart';
import 'package:consciousconsumer/screens/home/ingredients_screen.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/home/products_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'home/scanner.dart';

class ConsciousConsumer extends StatefulWidget{
  final CameraDescription camera;

  const ConsciousConsumer({super.key, required this.camera});

  @override
  State<ConsciousConsumer> createState()=>
      _ConsciousConsumerState();
}

class _ConsciousConsumerState extends State<ConsciousConsumer> {
  int _selectedIndex = 0;
  List<Icon> icons = [
    const Icon(Icons.history),
    const Icon(Icons.menu_book_rounded),
    const Icon(Icons.document_scanner),
    const Icon(Icons.no_food),
    const Icon(Icons.account_circle_rounded)
  ];

  final List<Widget> _widgets = [
    const ProductsScreen(),
    const IngredientsScreen(),
    const Text("Scanner", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black ),),
    const Text("Alergeny", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.red),),
    const AccountScreen(),
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 2
        ? ScannerScreen(camera: widget.camera) : _widgets[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: Constants.NAVIGATION_BAR_LAST_ICON,
            icon: icons[0],
          ),
          BottomNavigationBarItem(
            label: Constants.NAVIGATION_BAR_LIST_ICON,
            icon: icons[1],
          ),
          BottomNavigationBarItem(
            label: Constants.NAVIGATION_BAR_SCAN_ICON,
            icon: icons[2],
          ),
          BottomNavigationBarItem(
            label: Constants.NAVIGATION_BAR_ALLERGENS_ICON,
            icon: icons[3],
          ),
          BottomNavigationBarItem(
            label: Constants.NAVIGATION_BAR_ACCOUNT_ICON,
            icon: icons[4],
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.sea,
        selectedIconTheme: const IconThemeData(
          color: Constants.sea
        ),
        unselectedIconTheme: const IconThemeData(
          color: Constants.dark50
        ),
        onTap: _onItemTapped,

      ),
    );
  }
}