import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';

class MenuBackgroundWidget extends StatelessWidget {
  final String screenName;
  const MenuBackgroundWidget({super.key, required this.screenName});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height/3.5,
      child: Material(
        color: Colors.transparent,
        child: Stack(children: [
          ClipPath(
              clipper: ClipperPathBorder(screenSize),
              child: Container(color: Constants.darker)),
          ClipPath(
              clipper: MyClipperPath(screenSize),
              child: Stack(
                children: [
                  _buildBackgroundImage(screenSize),
                  _buildBackgroundBlur()],
              )),
          Positioned.fill(child: _builtAppName(context)),
          Positioned.fill(child: _builtScreenName(context)),
        ]),
      ),
    );
  }

  Container _builtScreenName(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(
          top: 18 * screenHeight / 100,
        ),
        child: Text(screenName,
            style: const TextStyle(
              fontSize: Constants.bigHeaderSize,
              color: Constants.light,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center));
  }

  Image _buildBackgroundImage(Size screenSize) {
    return Image.asset(
      Constants.assetsImage + Constants.backgroundImage,
      alignment: Alignment.topCenter,
      height: screenSize.height,
    );
  }

  BackdropFilter _buildBackgroundBlur() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
      child: Container(
        decoration: const BoxDecoration(color: Constants.darker70),
      ),
    );
  }

  Container _builtAppName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(top: screenHeight / 20),
        child: const Text(
          Constants.appName,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: Constants.theBiggestSize,
              letterSpacing: 3,
              color: Colors.white),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ));
  }
}

class MyClipperPath extends CustomClipper<Path> {
  final constSize;
  MyClipperPath(Size this.constSize);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(constSize.width, 0);
    path.lineTo(constSize.width, constSize.height / 5);
    path.lineTo(constSize.width / 2, constSize.height / 4);
    path.lineTo(0, constSize.height / 5);
    path.lineTo(0, constSize.height);
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
    path.moveTo(0, 0);
    path.lineTo(constSize.width, 0);
    path.lineTo(constSize.width, constSize.height / 5 + borderSize);
    path.lineTo(constSize.width / 2, constSize.height / 4 + borderSize);
    path.lineTo(0, constSize.height / 5 + borderSize);
    path.lineTo(0, constSize.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
