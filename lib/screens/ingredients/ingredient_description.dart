import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../models/enums.dart';
import '../../models/ingredient.dart';
import 'ingredient_item.dart';

class IngredientDescription extends StatefulWidget {
  final Ingredient ingredient;
  const IngredientDescription({required this.ingredient, super.key});


  static String harmfulnessToString(Harmfulness harmfulness) {
    switch (harmfulness) {
      case Harmfulness.good:
        return 'zdrowy';
      case Harmfulness.dangerous:
        return 'niebezpieczny';
      case Harmfulness.harmful:
        return 'szkodliwy';
      case Harmfulness.uncharted:
        return 'wpływ nieznany';
    }
  }

  @override
  State<IngredientDescription> createState() => _IngredientDescriptionState();
}

class _IngredientDescriptionState extends State<IngredientDescription> {
  final Container spacer = Container(
    margin: const EdgeInsets.symmetric(vertical: 20),
    width: double.infinity,
    height: 2,
    color: Constants.dark50,
  );

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Constants.dark,
          title: Text(
            IngredientItem.getNameToDisplay(widget.ingredient),
            style: const TextStyle(
                fontSize: Constants.headerSize),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: screenSize.width / 50),
                child: Column(
                  children: [
                    _buildTitle(screenSize),
                    _buildCategoryName(screenSize)
                  ],
                ),
              ),
              spacer,
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width / 20),
                child: Row(
                  children: [
                    IngredientItem.getHarmfulnessIconImage(
                        screenSize, widget.ingredient),
                    const Spacer(),
                    Text(
                      IngredientDescription.harmfulnessToString(widget.ingredient.harmfulness),
                      style: const TextStyle(fontSize: Constants.headerSize),
                    )
                  ],
                ),
              ),
              spacer,
              _buildIngredientDescription(screenSize),
            ],
          ),
        ));
  }

  Widget _buildTitle(Size screenSize) {
    return Container(
      alignment: Alignment.center,
      color: Constants.sea50,
      padding: EdgeInsets.only(
        top: screenSize.width / 30,
        left: screenSize.width / 30,
        right: screenSize.width / 30,
      ),
      child: Text(
        IngredientItem.getNameToDisplay(widget.ingredient),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: Constants.bigHeaderSize, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIngredientDescription(Size screenSize) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width / 25,
        ),
        child: Text(
          widget.ingredient.description,
          style: const TextStyle(fontSize: Constants.titleSize),
        ));
  }

  Widget _buildCategoryName(Size screenSize) {
    return Container(
      color: Constants.sea50,
      padding: EdgeInsets.only(
        right: screenSize.width / 50,
      ),
      margin: EdgeInsets.only(bottom: screenSize.width / 50),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          IngredientItem.getCategoryName(widget.ingredient)[0].toUpperCase() +
              IngredientItem.getCategoryName(widget.ingredient).substring(1),
          style: const TextStyle(fontSize: Constants.headerSize),
        ),
      ),
    );
  }


  Widget _buildFooter(Size screenSize) {
    return Container(
        padding: EdgeInsets.only(
            right: screenSize.width / 20,
            top: screenSize.width / 20,
            bottom: screenSize.width / 20),
        color: Constants.sea20,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Text(
            widget.ingredient.category.toString(),
            style: const TextStyle(
              fontSize: Constants.subTitleSize,
            ),
          ),
        ));
  }
}
