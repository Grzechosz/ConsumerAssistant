import 'package:cached_network_image/cached_network_image.dart';
import 'package:consciousconsumer/screens/loading.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/screens/ingredients/ingredient_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ProductItem extends HookWidget {
  final Function reload;
   const ProductItem({super.key, required this.item, required this.listLength, required this.reload});

  static int imageReadingAttempts = 0;
  static int ingredientsReadingAttempts = 0;
  final Product item;
  final int listLength;

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = ProductsService.storageService;
    final imageUrl = useState<String?>(null);
    final ingredients = useState<List<Ingredient>?>(null);
    _getIngredientsList(ingredients);
    _getImageUrl(imageUrl, storageService);
    Size screenSize = MediaQuery.of(context).size;
    return Card(
        color: Colors.white,
        child: GestureDetector(
          onLongPress: () => {_showOptionsDialog(context)},
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
                _getRemarks(screenSize),
                _getImage(screenSize, imageUrl)
              ],
            ),
            subtitle: Container(
              margin: EdgeInsets.only(top: screenSize.width / 50),
              child: _getDateTime(),
            ),
            children: [
              _getIngredients(ingredients),
            ],
          ),
        ));
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              Constants.askAboutAction,
              style: TextStyle(fontSize: Constants.headerSize),
            ),
            actions: [
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                      color: Constants.dark, fontSize: Constants.titleSize),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: () => _deleteProduct(context),
                child: const Text(
                  Constants.deleteText,
                  style: TextStyle(
                      color: Colors.red, fontSize: Constants.titleSize),
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
        item.productName[0].toUpperCase() + item.productName.substring(1),
        textAlign: TextAlign.center,
        maxLines: 2,
        style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: Constants.headerSize,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  void _getImageUrl(ValueNotifier<String?> imageUrl, StorageService storageService) async {
    storageService.addListener(() async {
      imageUrl.value = await storageService.getProductImage(item);
    });
    if (imageUrl.value == null && imageReadingAttempts < 3) {
        imageUrl.value = await storageService.getProductImage(item);
        imageReadingAttempts++;
    }
  }

  Widget _getDateTime() {
    String createdDate = item.createdDate.toString();
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

  Widget _getImage(Size screenSize, ValueNotifier<dynamic> imageUrl) {
    imageReadingAttempts -= 2;
    return Center(
      child: imageUrl.value != null
          ? ChangeNotifierProvider(
        create: (context) => StorageService(),
        child: CachedNetworkImage(
          memCacheWidth: 300,
          memCacheHeight: 300,
          width: screenSize.width / 1.5,
          progressIndicatorBuilder: (_, __, ___) =>
          const Center(child: Loading(isReversedColor: true)),
          imageUrl: imageUrl.value,
        ),
      )

          : const Loading(isReversedColor: true),
    );
  }

  Widget _getIconImage(Size screenSize) {
    String icon;
    if (item.rating == 1) {
      icon = Constants.assetsHarmfulnessIcons + Constants.goodIcon;
    } else if (item.rating == 2) {
      icon = Constants.assetsHarmfulnessIcons + Constants.harmfulIcon;
    } else if (item.rating == 3) {
      icon = Constants.assetsHarmfulnessIcons + Constants.dangerousIcon;
    } else {
      // rating 4
      icon = Constants.assetsHarmfulnessIcons + Constants.unchartedIcon;
    }
    return Container(
      margin: EdgeInsets.all(screenSize.width / 100),
      child: Image.asset(icon, scale: 8),
    );
  }

  Widget _getIngredients(ValueNotifier<List<Ingredient>?> ingredientsNotifier) {
    ingredientsReadingAttempts -= 2;
    List ingredients = ingredientsNotifier.value ?? [];
    return ingredients.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return (ingredients.isEmpty
                  ? const Center(
                      child: Text(
                        "Brak składników",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Constants.theBiggestSize,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  : IngredientItem(ingredients[index], true));
            },
          )
        : const Loading(isReversedColor: true);
  }

  void _getIngredientsList(
      ValueNotifier<List<Ingredient>?> ingredientsToReturn) async {
    if (ingredientsToReturn.value == null &&
        ingredientsReadingAttempts <= listLength) {
      List<Ingredient> ingredients = [];
      for (Future<Ingredient> ingredient in item.ingredients) {
        ingredients.add(await ingredient);
      }
      ingredientsToReturn.value = ingredients;
      ingredientsReadingAttempts++;
    }
  }

  void _deleteProduct(BuildContext context) {
    ProductsService(userId: FirebaseAuth.instance.currentUser!.uid)
        .deleteProduct(item);
    Navigator.pop(context);
    reload();
  }

  Widget _getRemarks(Size screenSize) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        item.remarks + (item.remarks.length > 0 ? '!' : ''),
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.red, fontSize: Constants.subTitleSize),
      ),
    );
  }
}
