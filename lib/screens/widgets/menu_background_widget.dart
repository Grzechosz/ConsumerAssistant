import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuBackgroundWidget extends StatelessWidget{
  final Widget child;
  const MenuBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(color: Constants.lightGreen),
          ClipPath(
              clipper: ClipperPathBorder(),
              child: Container(color: Constants.darkGreen)
          ),
            ClipPath(
              clipper: MyClipperPath(),
                child: Stack(
                  children: [
                    _buildBackgroundImage(),
                    _buildBackgroundBlur()
                  ],
              )
            ),
            Positioned.fill(child: _builtAppName(context)),
          child
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
        decoration: const BoxDecoration(color: Constants.darkestGreen80),
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
              color: Colors.white
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        )
    );
  }

}

class MyClipperPath extends CustomClipper<Path> {
  MyClipperPath();


  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(size.width,0);
    path.lineTo(size.width,size.height/4);
    path.lineTo(size.width/2,3*size.height/10);
    path.lineTo(0,size.height/4);
    path.lineTo(0,size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ClipperPathBorder extends CustomClipper<Path> {
  ClipperPathBorder();
  final int borderSize = 2;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(size.width,0);
    path.lineTo(size.width,size.height/4+borderSize);
    path.lineTo(size.width/2,3*size.height/10+borderSize);
    path.lineTo(0,size.height/4+borderSize);
    path.lineTo(0,size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}