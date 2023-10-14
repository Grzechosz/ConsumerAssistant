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
  
  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      _buildBackgroundImage(),
      _buildBackgroundBlur(),

      Scaffold(
        backgroundColor: Colors.transparent,
        body:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset(
                        Constants.ASSETS_IMAGE + Constants.LOGO_IMAGE,
                        height: 200,
                        width: 200,
                        alignment: Alignment.center,
                        ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            textStyle:
                            const TextStyle(
                              fontSize: 25,
                            ),
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(300, 50)
                        ),

                        child: const Text(Constants.LOG_IN),
                        onPressed: () async {
                          dynamic result = await _authentication.logIn();
                          if(result == AppUser.emptyUser) {

                          }else{

                          }
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            textStyle:
                            const TextStyle(
                              fontSize: 25,
                            ),
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(300, 50)
                        ),

                        child: const Text(Constants.SIGN_IN),
                        onPressed: () async {
                          dynamic result = await _authentication.signIn();
                          if(result == AppUser.emptyUser) {

                          }else{

                          }
                        },
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          textStyle:
                          const TextStyle(
                            fontSize: 25,
                          ),
                          backgroundColor: Colors.black54,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(300, 50)
                      ),

                      child: const Text(Constants.WITHOUT_LOG_IN),
                      onPressed: () async {
                        dynamic result = await _authentication.signInAnonymous();
                        if(result == AppUser.emptyUser) {

                        }else{

                        }
                      },
                    ),
                  ],
                ),
              ],
              )
      ),
    ],);
  }
}