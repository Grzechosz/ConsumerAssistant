import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountBackgroundWidget extends StatelessWidget{
  const AccountBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(color: Constants.sea80),
          ClipPath(
              clipper: ClipperPathBorder(MediaQuery.of(context).size),
              child: Container(color: Constants.dark80)
          ),
          ClipPath(
              clipper: MyClipperPath(MediaQuery.of(context).size),
              child: Container(color: Constants.light)
          ),
          Positioned.fill(child: _builtScreenName(context)),
        ]
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

  Container _builtScreenName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth*0.9,
        margin: EdgeInsets.only(top: screenHeight/13),
        child:
        const Text(
          Constants.accountDetails,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 45,
              letterSpacing: 5,
              color: Constants.dark
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        )
    );
  }

}

class MyClipperPath extends CustomClipper<Path> {
  final constSize;
  MyClipperPath(this.constSize);


  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(constSize.width,0);
    path.lineTo(constSize.width,22*constSize.height/100);
    path.lineTo(constSize.width/2,28*constSize.height/100);
    path.lineTo(0,22*constSize.height/100);
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
  final int borderSize = 1;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(constSize.width,0);
    path.lineTo(constSize.width,22*constSize.height/100+borderSize);
    path.lineTo(constSize.width/2,28*constSize.height/100+borderSize);
    path.lineTo(0,22*constSize.height/100+borderSize);
    path.lineTo(0,constSize.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}