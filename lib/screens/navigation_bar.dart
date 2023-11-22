import 'package:consciousconsumer/screens/account/account_screen.dart';
import 'package:consciousconsumer/screens/ingredients/ingredients_screen.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/last/products_screen.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';
import 'scan/scanner.dart';

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
            label: Constants.navigationBarLastIcon,
            icon: icons[0],
          ),
          BottomNavigationBarItem(
            label: Constants.navigationBarListIcon,
            icon: icons[1],
          ),
          BottomNavigationBarItem(
            label: Constants.navigationBarScanIcon,
            icon: icons[2],
          ),
          BottomNavigationBarItem(
            label: Constants.navigationBarAllergensIcon,
            icon: icons[3],
          ),
          BottomNavigationBarItem(
            label: Constants.navigationBarAccountIcon,
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