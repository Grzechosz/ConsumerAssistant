import 'dart:ui';

import 'package:consciousconsumer/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';

class AccountBackgroundWidget extends StatelessWidget {
  const AccountBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height / 3.5,
      child: Material(
        color: Colors.transparent,
        child: Stack(children: [
          ClipPath(
              clipper: MyClipperPath(MediaQuery.of(context).size),
              child: Container(color: Constants.sea80)),
          Positioned.fill(child: _builtScreenName(context)),
          Positioned.fill(child: _builtWelcome(context)),
        ]),
      ),
    );
  }

  Container _builtWelcome(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    User user = FirebaseAuth.instance.currentUser!;
    String? name = user.displayName;
    return Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(top: screenHeight / 7),
        child: Text(
          "Witaj, ${name ?? 'null'}!",
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Constants.bigHeaderSize,
              letterSpacing: 1,
              color: Constants.light),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ));
  }

  Container _builtScreenName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(top: screenHeight / 15),
        child: const Text(
          Constants.accountDetails,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Constants.theBiggestSize,
              letterSpacing: 1,
              color: Colors.white),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ));
  }
}

class MyClipperPath extends CustomClipper<Path> {
  final Size constSize;
  MyClipperPath(this.constSize);

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
