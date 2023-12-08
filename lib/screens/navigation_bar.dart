import 'package:consciousconsumer/screens/account/account_screen.dart';
import 'package:consciousconsumer/screens/ingredients/ingredients_screen.dart';
import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/last/products_screen.dart';
import 'package:consciousconsumer/services/notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';
import 'articles/articles_screen.dart';
import 'scan/scanner_screen.dart';

class ConsciousConsumer extends StatefulWidget {
  final CameraDescription camera;

  const ConsciousConsumer({super.key, required this.camera});

  @override
  State<ConsciousConsumer> createState() => _ConsciousConsumerState();
}

class _ConsciousConsumerState extends State<ConsciousConsumer> {
  int _selectedIndex = 0;
  List<Icon> icons = [
    const Icon(Icons.history),
    const Icon(Icons.menu_book_rounded),
    const Icon(Icons.document_scanner),
    const Icon(Icons.article),
    const Icon(Icons.account_circle_rounded)
  ];

  final List<Widget> _widgets = [
    const ProductsScreen(),
    const IngredientsScreen(),
    const ScannerScreen(),
    const ArticlesScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    NotificationsService(uid: FirebaseAuth.instance.currentUser!.uid)
        .initNotifications();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgets[_selectedIndex],
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
            label: Constants.navigationBarArticlesIcon,
            icon: icons[3],
          ),
          BottomNavigationBarItem(
            label: Constants.navigationBarAccountIcon,
            icon: icons[4],
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.sea,
        selectedIconTheme: const IconThemeData(color: Constants.sea),
        unselectedIconTheme: const IconThemeData(color: Constants.dark50),
        onTap: _onItemTapped,
      ),
    );
  }

  void navigateToLast() {
    setState(() {
      _selectedIndex = 0;
    });
  }
}
