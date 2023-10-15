import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {

  final AuthenticationService _authentication = AuthenticationService();

  Image _buildBackgroundImage(){
    return Image.asset(Constants.ASSETS_IMAGE + Constants.BACKGROUND_IMAGE,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  BackdropFilter _buildBackgroundBlur(){
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
      ),
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
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                color: Colors.black54
              ),
              width: MediaQuery.of(context).size.width*0.75,
              height: MediaQuery.of(context).size.height*0.3,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildEmailField(),
                  _buildPasswordField(),
                  _buildLogInButton(),
                ],
              ),
            ),

            _buildSignInButton(),
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

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _buildBackgroundImage(),
        _buildBackgroundBlur(),
        _builtScreenElements(),
      ],)
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
      padding: const EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height*0.07,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500
            ),
            backgroundColor: const Color(0xFFDDDDDD),
            foregroundColor: Colors.black,
            minimumSize: Size(MediaQuery.of(context).size.width*0.45, MediaQuery.of(context).size.height*0.06)
        ),
        child: const Text(Constants.LOG_IN),
        onPressed: () async {
          dynamic result = await _authentication.logIn();
          if(result == AppUser.emptyUser) {

          }else{

          }
        },
      ),
    );
  }

  Widget _buildSignInButton(){
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 25,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.5, MediaQuery.of(context).size.height*0.05)
        ),
        child: const Text(Constants.SIGN_IN),
        onPressed: () async {
          dynamic result = await _authentication.signIn();
          if(result == AppUser.emptyUser) {

          }else{

          }
        },
      ),
    );
  }

  Widget _buildLogInAnonymousButton(){
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 25,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.5, MediaQuery.of(context).size.height*0.05)
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