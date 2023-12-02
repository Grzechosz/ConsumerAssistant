import 'package:cached_network_image/cached_network_image.dart';
import 'package:consciousconsumer/screens/articles/article_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../models/article.dart';
import '../../services/storage_service.dart';
import '../loading.dart';

class ArticleItem extends StatefulWidget{
  final Article article;
  const ArticleItem(this.article, {super.key});

  @override
  State<StatefulWidget> createState() => _ArticleItemState(article);
}

class _ArticleItemState extends State<ArticleItem>{

  final Article item;
  String? imageUrl;

  _ArticleItemState(this.item);

  @override
  Widget build(BuildContext context) {
    _getImageUrl();
    Size screenSize = MediaQuery.of(context).size;
    return Card(
        margin: EdgeInsets.symmetric(horizontal: screenSize.width/40,
            vertical: screenSize.height/150),
        color: Colors.white,
        child: GestureDetector(
          onTap: ()=>pushArticleBody(),
          child: Container(
            margin: EdgeInsets.all(screenSize.width/30),
            child: Column(
              children: [
                _getImage(screenSize),
                Container(
                  margin: EdgeInsets.only(top: screenSize.width/50,
                      left: screenSize.width/50,
                  right: screenSize.width/50),
                  child:
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20,)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(item.date.toString().substring(0, 10),
                      style: const TextStyle(
                        color: Constants.dark50,
                        fontSize: 15,
                      )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void _getImageUrl() async {
    StorageService service = StorageService();
    String url = await service.getArticleImage(item);
    if(imageUrl == null) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  Widget _getImage(Size screenSize){
    return Center(child:
    imageUrl!=null ? CachedNetworkImage(
      width: screenSize.width/1.1,
      progressIndicatorBuilder: (_,__,___)=>
      const Center(
          child: Loading(isReversedColor: true)),
      imageUrl: imageUrl!,) :
    const Loading(isReversedColor: true),) ;
  }

  void pushArticleBody() {
    Navigator.push(context,
        PageRouteBuilder(pageBuilder: (q,w,e) => ArticleBody(article: item,),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                SlideTransition(
                  position: Tween(
                    begin: const Offset(0.0, -1.0),
                    end: const Offset(0.0, 0.0),)
                      .animate(animation),
                  child: child,
                ))
    );
  }
}