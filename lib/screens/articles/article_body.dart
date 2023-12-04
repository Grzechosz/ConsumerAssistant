import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../config/constants.dart';
import '../../models/article.dart';
import '../../services/storage_service.dart';
import '../loading.dart';

class ArticleBody extends StatefulWidget{
  final Article article;
  const ArticleBody({required this.article, super.key});

  @override
  State<StatefulWidget> createState() =>_ArticleBodyState();
}

class _ArticleBodyState extends State<ArticleBody>{
  String? imageUrl;
  final Container spacer = Container(
    margin: const EdgeInsets.symmetric(vertical: 20),
    width: double.infinity,
    height: 2,
    color: Constants.dark50,
  );

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    _getImageUrl();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Constants.dark,
        title: Text(widget.article.title,
          style: const TextStyle(
              fontSize: Constants.headerSize
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getImage(screenSize),
            Container(
              padding: EdgeInsets.only(top: screenSize.width/50),
              child: Column(
                children:[
                  _buildTitle(screenSize),
                  _buildArticleDate(screenSize),],
              ),
            ),
            spacer,
            _buildArticleBody(screenSize),
            spacer,
            _buildAuthorData(screenSize),
          ],
        ),
      )

    );
  }

  Widget _buildTitle(Size screenSize){
    return Container(
      alignment: Alignment.center,
      color: Constants.sea50,
      padding: EdgeInsets.only(top: screenSize.width/30,
          left: screenSize.width/30,
          right: screenSize.width/30,),
      child: Text(widget.article.title,
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontSize: Constants.bigHeaderSize,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildArticleBody(Size screenSize){
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.width/25,),
      child: Html(
        data: widget.article.body,
      )
    );
  }

  Widget _buildAuthorData(Size screenSize){
    return Container(
      padding: EdgeInsets.only(right: screenSize.width/20,
      top: screenSize.width/20, bottom: screenSize.width/20),
      color: Constants.sea20,
      child:Align(
          alignment: Alignment.bottomRight,
          child: Text(widget.article.author,
            style: const TextStyle(
                fontSize: Constants.subTitleSize,
            ),
          ),
        )
    );
  }

  void _getImageUrl() async {
    StorageService service = StorageService();
    String url = await service.getArticleImage(widget.article);
    if(imageUrl == null) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  Widget _getImage(Size screenSize){
    return Container(
      margin: EdgeInsets.only(top: screenSize.width/50,),
      child:     imageUrl!=null ? CachedNetworkImage(
        progressIndicatorBuilder: (_,__,___)=>
        const Center(
            child: Loading(isReversedColor: true)),
        imageUrl: imageUrl!,) :
      const Loading(isReversedColor: true)
    );
  }

  Widget _buildArticleDate(Size screenSize) {
    return Container(
      color: Constants.sea50,
      padding: EdgeInsets.only(right: screenSize.width/50,),
      margin: EdgeInsets.only(
          bottom: screenSize.width/50),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(widget.article.date.toString().substring(0, 10),
          style: const TextStyle(
              fontSize: Constants.subTitleSize
          ),
        ),
      ),
    );
  }
}