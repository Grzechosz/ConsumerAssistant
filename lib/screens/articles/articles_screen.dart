import 'package:consciousconsumer/screens/articles/article_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:consciousconsumer/screens/loading.dart';

class ArticlesScreen extends StatefulWidget{
  const ArticlesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ArticlesScreenState();

}

class _ArticlesScreenState extends State<ArticlesScreen>{
  late List articles;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Constants.sea80,
      child: _buildArticles(screenSize),
    );
  }


  Container _buildArticles(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.height/20),
      child: StreamProvider<List<Article>>.value(
        value: ArticlesService().articles,
        initialData: const [],
        builder: (context, child) =>
          _buildArticlesList(context),
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context){
    articles = Provider.of<List<Article>>(context);
    Size screenSize = MediaQuery.of(context).size;
    if(ArticlesService.isLoaded){
      articles.sort((art1, art2){
        return art1.date.isBefore(art2.date)? 1 : -1;
      });
      return SizedBox(
        height: screenSize.height/4.5,
          child: articles.isEmpty ?
              const Center(
                child: Text("Brak artykułów",
                  style: TextStyle(letterSpacing: 0.5,
                    fontSize: Constants.theBiggestSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),),
              ) : ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:articles.length,
                  itemBuilder:(context, index) {
                    return SizedBox(
                      width: screenSize.width/1.2,
                      child: ArticleItem(articles[index]),
                    );
                  }
              )
      );
    }else{
      return const Loading(isReversedColor:false);
    }
  }

}