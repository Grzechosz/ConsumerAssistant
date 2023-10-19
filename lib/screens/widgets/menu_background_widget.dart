import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuBackgroundWidget extends StatelessWidget{
  final Widget child;
  final String screenName;
  const MenuBackgroundWidget({super.key, required this.child, required this.screenName});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(color: Constants.light),
          ClipPath(
              clipper: ClipperPathBorder(MediaQuery.of(context).size),
              child: Container(color: Constants.darker)
          ),
            ClipPath(
              clipper: MyClipperPath(MediaQuery.of(context).size),
                child: Stack(
                  children: [
                    _buildBackgroundImage(),
                    _buildBackgroundBlur()
                  ],
              )
            ),
            Positioned.fill(child: _builtAppName(context)),
            Positioned.fill(child: _builtScreenName(context)),
          child
        ]
    );
  }

  Container _builtScreenName(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top: screenHeight/4,),
        child: Text(screenName,
                  style: const TextStyle(
                      fontSize: 28,
                      color: Constants.light,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,

                      ),
                  textAlign: TextAlign.center
        )
    );
  }
  Image _buildBackgroundImage(){
    return Image.asset(Constants.ASSETS_IMAGE + Constants.BACKGROUND_IMAGE,
      fit: BoxFit.contain,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.topCenter,
    );
  }

  BackdropFilter _buildBackgroundBlur(){
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: 0.5,
          sigmaY: 0.5
      ),
      child: Container(
        decoration: const BoxDecoration(color: Constants.darker70),
      ),
    );
  }

  Container _builtAppName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth*0.9,
        margin: EdgeInsets.only(top: screenHeight/13),
        child:
        const Text(
          Constants.APP_NAME,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 40,
              letterSpacing: 2,
              color: Constants.light
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        )
    );
  }

}

class MyClipperPath extends CustomClipper<Path> {
  final constSize;
  MyClipperPath(Size this.constSize);


  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(constSize.width,0);
    path.lineTo(constSize.width,28*constSize.height/100);
    path.lineTo(constSize.width/2,constSize.height/3);
    path.lineTo(0,28*constSize.height/100);
    path.lineTo(0,constSize.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ClipperPathBorder extends CustomClipper<Path> {
  final constSize;
  ClipperPathBorder(Size this.constSize);
  final int borderSize = 2;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(constSize.width,0);
    path.lineTo(constSize.width,28*constSize.height/100+borderSize);
    path.lineTo(constSize.width/2,constSize.height/3+borderSize);
    path.lineTo(0,28*constSize.height/100+borderSize);
    path.lineTo(0,constSize.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}