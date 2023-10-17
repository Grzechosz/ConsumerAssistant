import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/screens/widgets/menu_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../widgets/log_in_widgets.dart';

class LogIn extends StatefulWidget {
  final Function changeRegisterView;


  const LogIn({super.key, required this.changeRegisterView});

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> with SingleTickerProviderStateMixin{
  
  final AuthenticationService _authentication = AuthenticationService();
  late LogInButton logInButton = LogInButton(function: () async {
        if(_formKeyEmail.currentState!.validate() && _formKeyPasswd.currentState!.validate()){
          dynamic result = await _authentication.logIn(emailFieldContainer.email,
              passwordFieldContainer.password);
          if(result == AppUser.emptyUser){
            setState(() {
              error = "Nieprawidłowe dane";
            });
          }
        }
      });

  late EmailFieldContainer emailFieldContainer = EmailFieldContainer(formKeyEmail: _formKeyEmail,);
  late PasswordFieldContainer passwordFieldContainer = PasswordFieldContainer(formKeyPasswd: _formKeyPasswd,);
  late String
      error='';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>();

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
        body:
          MenuBackgroundWidget(
            child: _builtScreenElements()),
    );
  }

  Row _builtScreenElements(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3) ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width*0.04),
                child: const Text("Wprowadź email i hasło",
                  style: TextStyle(
                      fontSize: 22,
                      color: Constants.darkGreen,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              emailFieldContainer,
              passwordFieldContainer,
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(error,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red
                  ),
                ),
              ),
              RemindPasswordButton(function: widget.changeRegisterView),
              logInButton,
              RegisterButton(function: widget.changeRegisterView),
            ],
          ),
        )

      ],
    );
  }
}