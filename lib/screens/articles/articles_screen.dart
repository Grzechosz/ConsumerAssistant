import 'package:consciousconsumer/screens/ingredients/ingredients_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../models/article.dart';
import '../../services/articles_service.dart';
import '../loading.dart';

class ArticlesScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ArticlesScreenState();

}

class _ArticlesScreenState extends State<ArticlesScreen>{
  late List articles;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Constants.sea80,
      child: Column(children: [
        // _buildCategoriesList(screenSize),
        _buildArticles()
      ]),
    );
  }


  StreamProvider _buildArticles(){
    return StreamProvider<List<Article>>.value(
      value: ArticlesService().articles,
      initialData: const [],
      builder: (context, child) {
        return Expanded(
          child: _buildArticlesList(context),
        );
      },
    );
  }

  Widget _buildArticlesList(BuildContext context){
    articles = Provider.of<List<Article>>(context);
    if(ArticlesService.isLoaded){
      return ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: articles.length,
        itemBuilder:(context, index) {
          return (articles.isEmpty ?
          const Center(
            child: Text("Brak Artykułów"),
          ) :
          ListTile(
            title: articles[index].title,
          ));
        }
      );
    }else{
      return const Loading(isReversedColor:false);
    }
  }

  // Widget _buildCategoriesList(Size screenSize) {
  //   return Container(
  //     height: screenSize.height/5.2,
  //     margin: const EdgeInsets.only(bottom: 5),
  //     child: ListView.builder(
  //         padding: const EdgeInsets.only(top: 0),
  //         scrollDirection: Axis.horizontal,
  //         shrinkWrap: true,
  //         itemCount:_categoriesList.length,
  //         itemBuilder:(context, index) {
  //           return SizedBox(
  //             width: screenSize.width/2.5,
  //             child: Card(
  //               color: Colors.white,
  //               child: ListTile(
  //                 onTap: (){
  //                   setState(() {
  //                     checkedCategory = index-1>=0 ? enums.Category.values.elementAt(index-1) : null;
  //                   });
  //                 },
  //                 title: Text((_categoriesList[index] as String)[0].toUpperCase()
  //                     +(_categoriesList[index] as String).substring(1),
  //                   textAlign: TextAlign.center,
  //                   style: const TextStyle(
  //                       fontSize: 18
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 subtitle: Image.asset("${Constants.assetsCategoriesIcons}"
  //                     "${index-1>=0 ? enums.Category.values.elementAt(index-1).name : "all"}"
  //                     ".png"),
  //               ),
  //             ),
  //           );
  //         }
  //     ),
  //   );
  // }
}