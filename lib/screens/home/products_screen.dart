import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/services/products_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../loading.dart';
import '../../models/product.dart';
import '../sorting_and_filtering.dart';
import '../widgets/products/product_item.dart';

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
        //_buildSortBy(screenSize),
        _buildProducts()
      ]),
    );
  }

  Widget _buildSearchBox(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/20, left: screenSize.width/40, right: screenSize.width/40),
      decoration: BoxDecoration(
          border: Border.all(),
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
                color: Constants.dark50,),
              hintStyle: TextStyle(
                  color: Constants.dark50,
                  fontSize: 20
              ),
              hintText: Constants.SEARCH_TEXT,
              border: InputBorder.none
          )
      ),
    );
  }

  StreamProvider _buildProducts(){
    return StreamProvider<List<Product>>.value(
      value: ProductsService(userId: FirebaseAuth.instance.currentUser!.uid).products,
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
    products = SortingAndFiltering.productsFilter(searchText, allProducts).toList();

    if(ProductsService.isLoaded){
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder:(context, index) {
          return (products.isEmpty ?
          const Center(
            child: Text("Brak Produktów"),
          ) :
          ListTile(title: ProductItem(item: products[index],)));
        },
      );
    }else{
      return const Loading(isReversedColor: false,);
    }
  }
}