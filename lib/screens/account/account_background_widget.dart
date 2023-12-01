import 'dart:ui';

import 'package:consciousconsumer/models/app_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';

class AccountBackgroundWidget extends StatelessWidget{
  const AccountBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(color: Constants.sea80),
          ClipPath(
              clipper: MyClipperPath(MediaQuery.of(context).size),
              child: Container(color: Constants.light)
          ),
          Positioned.fill(child: _builtScreenName(context)),
          Positioned.fill(child: _builtWelcome(context)),
        ]
    );
  }

  Container _builtWelcome(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    AppUser user = Provider.of<AppUser>(context);

    String name = user.name;
    if (name == 'null'){
      name = user.email;
      if(name.contains(RegExp('@'))){
        name = name.substring(0, name.indexOf(RegExp('@')));
        name = name[0].toUpperCase() + name.substring(1);
      }
    }

    return Container(
        width: screenWidth*0.9,
        margin: EdgeInsets.only(top: screenHeight/6),
        child:
        Text(
          "Witaj, ${name}!",
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32,
              letterSpacing: 1,
              color: Constants.dark80
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        )
    );
  }

  Container _builtScreenName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth*0.9,
        margin: EdgeInsets.only(top: screenHeight/12),
        child:
        const Text(
          Constants.accountDetails,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 45,
              letterSpacing: 1,
              color: Constants.dark
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        )
    );
  }

}

class MyClipperPath extends CustomClipper<Path> {
  final Size constSize;
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