import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/screens/widgets/menu_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

class LogInOrRegister extends StatefulWidget {
  final Function changeRegisterView;
  final Function changeLogInView;

  const LogInOrRegister.LogInOrRegister({super.key, required this.changeRegisterView, required this.changeLogInView});

  @override
  LogInOrRegisterState createState() => LogInOrRegisterState();
}

class LogInOrRegisterState extends State<LogInOrRegister> {
  final AuthenticationService _authentication = AuthenticationService();

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          const MenuBackgroundWidget(),
          _builtScreenElements(),
        ],)
    );
  }

  Row _builtScreenElements(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _builtAppLogo(),
            _builtAppName(),
            _buildLogInButton(),
            _buildRegisterButton(),
            _buildLogInAnonymousButton()
          ],
        ),
      ],
    );
  }

  Container _builtAppLogo(){
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Image.asset(
        Constants.ASSETS_IMAGE + Constants.LOGO_IMAGE,
        height: 100,
        width: 100,
        alignment: Alignment.center,
      ),
    );
  }


  Container _buildEmailField(){
    return Container(
        height: MediaQuery.of(context).size.height*0.07,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Colors.black38,
                width: 2
            ),
            color: Colors.white
        ),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  size: 30,
                  color: Colors.black26,),
                hintStyle: TextStyle(
                    color: Colors.black26,
                    fontSize: 20
                ),
                hintText: 'Email',
                border: InputBorder.none
            )
        )
    );
  }

  Widget _buildPasswordField(){
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: MediaQuery.of(context).size.height*0.07,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Colors.black38,
                width: 2
            ),
            color: Colors.white
        ),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  size: 30,
                  color: Colors.black26,),
                hintStyle: TextStyle(
                    color: Colors.black26,
                    fontSize: 20
                ),
                hintText: 'Password',
                border: InputBorder.none
            )
        )
    );
  }

  Widget _buildLogInButton(){
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 35,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.height*0.08)
        ),
        child: const Text(Constants.LOG_IN),
        onPressed: () {
          widget.changeLogInView();
        },
      ),
    );
  }

  Widget _buildRegisterButton(){
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 35,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.height*0.08)
        ),
        child: const Text(Constants.REGISTER),
        onPressed: () {
          widget.changeRegisterView();
        },
      ),
    );
  }

  Widget _buildLogInAnonymousButton(){
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 35,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.height*0.08)
        ),
        child: const Text(Constants.WITHOUT_LOG_IN),
        onPressed: () async {
          dynamic result = await _authentication.signInAnonymous();
          if(result == AppUser.emptyUser) {

          }else{

          }
        },
      ),
    );
  }

  Container _builtAppName() {
    return Container(
        width: MediaQuery.of(context).size.width*0.9,
        margin: const EdgeInsets.all(15),
        child: Center(
          child: Stack(
            children: [
              Text(
                Constants.APP_NAME,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 50,
                  letterSpacing: 2,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.black,
                ),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              const Text(
                Constants.APP_NAME,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                    letterSpacing: 2,
                    color: Colors.white
                ),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
    );
  }
}