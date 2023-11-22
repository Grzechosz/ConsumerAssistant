import 'package:consciousconsumer/models/ingredient.dart';
import 'package:flutter/material.dart';

import '../authentication/menu_background_widget.dart';

class IngredientDescription extends StatelessWidget{
  const IngredientDescription({super.key, required this.ingredient});
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      MenuBackgroundWidget(
          screenName: ingredient.names[0],
          child: Stack(
            children: [
              Text(ingredient.description),
              ElevatedButton(
                onPressed: () { Navigator.pop(context); },
                child: const Text("Kliknij mie"),)
            ],
          )
      ),
    );

  }

}