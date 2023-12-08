import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../../services/authentication_service.dart';


class AccountBackgroundWidget extends StatefulWidget {
  String? name;
  final AuthenticationService authService;

  AccountBackgroundWidget({super.key, required this.authService});

  @override
  State<StatefulWidget> createState() => _AccountBackgroundWidgetState();
}

class _AccountBackgroundWidgetState extends State<AccountBackgroundWidget>
{

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    widget.name = user.displayName??'';
    widget.authService.addListener(() {
      if(mounted) {
        setState(() {
          widget.name = user.displayName;
      });
      }
    });

    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height / 3.6,
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

    return Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(top: screenHeight / 7),
        child: Text(
          "Witaj, ${widget.name ?? 'null'}!",
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
