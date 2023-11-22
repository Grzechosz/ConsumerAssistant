
import 'package:consciousconsumer/screens/loading.dart';
import 'package:consciousconsumer/models/product.dart';
import 'package:consciousconsumer/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../models/ingredient.dart';
import '../ingredients/ingredient_item.dart';

class ProductItem extends StatefulWidget{
  final Product item;

  const ProductItem({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _ProductItemState();

}

class _ProductItemState extends State<ProductItem> {
  _ProductItemState();
  NetworkImage? image;
  List<Ingredient>? ingredients;

  @override
  Widget build(BuildContext context) {
    _getIngredientsList();
    _getImageUrl();
    Size screenSize = MediaQuery.of(context).size;
    return Card(
        color: Colors.white,
        child: GestureDetector(

          onLongPress: ()=>{
            _showOptionsDialog()
          },
          child: ExpansionTile(
            textColor: Constants.sea,
            expandedCrossAxisAlignment: CrossAxisAlignment.end,
            leading: Column(
              children: [
                _getIconImage(screenSize),
                // Container(
                //   margin: EdgeInsets.only(top: screenSize.width/80),
                //     child: Text(widget.item.rating.toString())
                // )
              ],
            ),
            shape: const Border(
                bottom: BorderSide(
                    color: Constants.dark50
                )
            ),
            title: Column(
              children: [
                _getNameToDisplay(screenSize),
                _getImage(screenSize)
              ],
            ),
            subtitle: _getDateTime(),
            children: [
              _getIngredients(),
            ],
          ),
        )
    );
  }

  void _showOptionsDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            // icon: const Icon(
            //   Icons.delete,
            //   size: 50,
            //   color: Colors.red,
            // ),
            title: const Text(Constants.askAboutAction),
            actions: [
              TextButton(
                child: const Text(Constants.cancelText,
                  style: TextStyle(
                    color: Constants.dark,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(Constants.editText,
                  style: TextStyle(
                    color: Constants.sea,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(Constants.deleteText,
                  style: TextStyle(
                    color: Colors.red,
                  ),),
                onPressed: () { },
              ),
            ],
          );
        });
  }

  Widget _getNameToDisplay(Size screenSize) {
    return Container(
      padding: EdgeInsets.all(screenSize.width/30),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.item.productName,
          style: const TextStyle(
              fontSize: 18
          ),),),
    );
  }


  void _getImageUrl() async {
    StorageService service = StorageService();
    String url = await service.getProductImage(widget.item);
    if(image == null) {
      setState(() {
      image = NetworkImage(url);
    });
    }
  }

  Widget _getDateTime(){
    String createdDate = widget.item.createdDate.toString();
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        createdDate.substring(0, createdDate.length-7),
        style: const TextStyle(
            color: Constants.dark,
            fontSize: 14,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  Widget _getImage(Size screenSize){
    return Center(child:
    image!=null ? Image(
      image: image!,
      width: screenSize.width/2,
      height: screenSize.width/2,) :
    const Loading(isReversedColor: true),) ;
  }

  Widget _getIconImage(Size screenSize) {
    String icon;
    if(widget.item.rating<0.33){
      icon = Constants.assetsHarmfulnessIcons + Constants.dangerousIcon;
    }else if(widget.item.rating<0.66){
      icon = Constants.assetsHarmfulnessIcons + Constants.harmfulIcon;
    }else{
      icon = Constants.assetsHarmfulnessIcons + Constants.goodIcon;
    }
    return Expanded(child: Image.asset(icon, scale: 5));
  }

  Widget _getIngredients() {
    return ingredients!=null ? ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients!.length,
      itemBuilder:(context, index) {
        return (ingredients!.isEmpty ?
        const Center(
          child: Text("Brak składników"),
        ) :
        ListTile(title: IngredientItem(ingredients![index])));
            //Text(ingredients[index].names[0]));
      },
    ) : const Loading(isReversedColor: false);
  }

  Future<void> _getIngredientsList() async {
    List<Ingredient> ingredients = [];
    for(Future<Ingredient> ingredient in widget.item.ingredients){
      ingredients.add(await ingredient);
    }
    if(this.ingredients == null) {
      setState(() {
        this.ingredients = ingredients;
      });
    }
  }
}

  extension StringExtension on String {
  String firstLetterUpper() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
