import 'package:consciousconsumer/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/screens/loading.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/screens/ingredients/sorting_and_filtering.dart';
import 'product_item.dart';

class ProductsScreen extends StatefulWidget{
  const ProductsScreen({super.key});
  @override
  State<StatefulWidget> createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen>{

  List products = [];
  List allProducts = [];
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Constants.sea80,
      child: Column(children: [
        _buildSearchBox(screenSize),
        _buildProducts()
      ]),
    );
  }

  Widget _buildSearchBox(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/20,
        left: screenSize.width/100,
        right: screenSize.width/100,
          bottom: screenSize.height/150),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white),

      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
          onChanged: (text)=>setState(() {
            searchText = text;
          }),
          decoration: const InputDecoration(
              icon: Icon(
                Icons.search,
                size: 30,
                color: Constants.dark80,),
              hintStyle: TextStyle(
                  color: Constants.dark50,
                  fontSize: Constants.headerSize,
              ),
              hintText: Constants.searchText,
              border: InputBorder.none
          )
      ),
    );
  }

  StreamProvider _buildProducts(){
    return StreamProvider<List<Product>>.value(
      value: ProductsService(userId: FirebaseAuth.instance
          .currentUser!.uid).products,
      initialData: const [],
      builder: (context, child) {
        return Expanded(
          child: _buildProductsList(context),
        );
      },
    );
  }

  Widget _buildProductsList(BuildContext context){
    allProducts = Provider.of<List<Product>>(context);
    products = SortingAndFiltering
        .productsFilter(searchText, allProducts)
        .toList();
    SortingAndFiltering.productsSorting(products);

    ProductItem.ingredientsReadingAttempts=0;
    ProductItem.imageReadingAttempts=0;

    if(ProductsService.isLoaded){
        return products.isNotEmpty ? ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder:(context, index) =>
          ProductItem(item: products[index], listLength: products.length
      )) : const Center(
          child: Text("Brak Produktów",
          style: TextStyle(letterSpacing: 0.5,
            fontSize: Constants.theBiggestSize,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),),
        );

    }else{
      return const Loading(isReversedColor: false,);
    }
  }
}