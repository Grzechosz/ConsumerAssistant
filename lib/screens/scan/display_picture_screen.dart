import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen(
      {super.key,
        required this.imagePath,
        required this.image_discription,
        required this.ingredientsList});
  @override
  State<StatefulWidget> createState() => DisplayPictureScreenState();

  final String imagePath;
  final String image_discription;
  final List<String> ingredientsList;
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late List allIngredients;
  late List ingredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Image.file(File(widget.imagePath)),
          // SingleChildScrollView(child: Text(widget.image_discription)),

        ],
      ),
    );
  }
}