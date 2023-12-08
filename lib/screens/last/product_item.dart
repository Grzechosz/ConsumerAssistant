import 'package:cached_network_image/cached_network_image.dart';
import 'package:consciousconsumer/screens/loading.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/screens/ingredients/ingredient_item.dart';

class ProductItem extends StatefulWidget {
  final Product item;

  const ProductItem({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  _ProductItemState();
  String? imageUrl;
  List<Ingredient>? ingredients;

  @override
  Widget build(BuildContext context) {
    _getIngredientsList();
    _getImageUrl();
    Size screenSize = MediaQuery.of(context).size;
    return Card(
        color: Colors.white,
        child: GestureDetector(
          onLongPress: () => {_showOptionsDialog()},
          child: ExpansionTile(
            textColor: Constants.sea,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _getIconImage(screenSize),
                    Expanded(child: _getNameToDisplay(screenSize))
                  ],
                ),
                _getImage(screenSize)
              ],
            ),
            subtitle: Container(
              margin: EdgeInsets.only(top: screenSize.width / 50),
              child: _getDateTime(),
            ),
            children: [
              _getIngredients(),
            ],
          ),
        ));
  }

  void _showOptionsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(Constants.askAboutAction,
            style: TextStyle(
              fontSize: Constants.headerSize
            ),),
            actions: [
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                    color: Constants.dark,
                      fontSize: Constants.titleSize
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  Constants.editText,
                  style: TextStyle(
                    color: Constants.sea,
                      fontSize: Constants.titleSize
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: _deleteProduct,
                child: const Text(
                  Constants.deleteText,
                  style: TextStyle(
                    color: Colors.red,
                      fontSize: Constants.titleSize
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _getNameToDisplay(Size screenSize) {
    return Container(
      padding: EdgeInsets.all(screenSize.width / 50),
      child: Text(
        widget.item.productName[0].toUpperCase() +
            widget.item.productName.substring(1),
        textAlign: TextAlign.center,
        maxLines: 2,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: Constants.headerSize,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  void _getImageUrl() async {
    StorageService service = StorageService();
    String url = await service.getProductImage(widget.item);
    if (imageUrl == null && mounted) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  Widget _getDateTime() {
    String createdDate = widget.item.createdDate.toString();
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        createdDate.substring(0, 16),
        style: const TextStyle(
            color: Constants.dark80,
            fontSize: Constants.subTitleSize,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _getImage(Size screenSize) {
    return Center(
      child: imageUrl != null
          ? CachedNetworkImage(
              width: screenSize.width / 2.5,
              progressIndicatorBuilder: (_, __, ___) =>
                  const Center(child: Loading(isReversedColor: true)),
              imageUrl: imageUrl!,
            )
          : const Loading(isReversedColor: true),
    );
  }

  Widget _getIconImage(Size screenSize) {
    String icon;
    if (widget.item.rating < 0.33) {
      icon = Constants.assetsHarmfulnessIcons + Constants.dangerousIcon;
    } else if (widget.item.rating < 0.66) {
      icon = Constants.assetsHarmfulnessIcons + Constants.harmfulIcon;
    } else {
      icon = Constants.assetsHarmfulnessIcons + Constants.goodIcon;
    }
    return Container(
      margin: EdgeInsets.all(screenSize.width / 100),
      child: Image.asset(icon, scale: 8),
    );
  }

  Widget _getIngredients() {
    if (ingredients != null) {
      return ingredients!.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ingredients!.length,
              itemBuilder: (context, index) {
                return (ingredients!.isEmpty
                    ? const Center(
                        child: Text(
                          "Brak składników",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Constants.theBiggestSize,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : IngredientItem(ingredients![index], true));
              },
            )
          : const Loading(isReversedColor: true);
    }else{
      return const Loading(isReversedColor: true);
    }
  }

  Future _getIngredientsList() async {
    List<Ingredient> ingredients = [];
    for (Future<Ingredient> ingredient in widget.item.ingredients) {
      ingredients.add(await ingredient);
    }
    if (this.ingredients == null) {
      setState(() {
        this.ingredients = ingredients;
      });
    }
  }

  void _deleteProduct() {
    setState(() {
      ProductsService(userId: FirebaseAuth.instance.currentUser!.uid)
          .deleteProduct(widget.item);
      _getImageUrl();
    });
    Navigator.pop(context);
  }
}
