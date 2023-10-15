import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../widgets/menu_background_widget.dart';

class LogIn extends StatefulWidget {
  final Function changeLogInView;
  const LogIn({super.key, required this.changeLogInView});

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {

  final AuthenticationService _authentication = AuthenticationService();
  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>();

  late String email,
      password,
      error='';

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
            _buildLogInContainer(),
            _buildReturnButton(),
            _buildRemindPasswordButton()
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
        child: Form(
          key: _formKeyEmail,
          child: TextFormField(
              onChanged: (value) {
                setState(() => email = value);
                _formKeyEmail.currentState!.validate();
              },
              validator: (val)=> val!.isEmpty ? "Wprowadź email" : null,
              decoration: const InputDecoration(
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
          ),
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
        child: Form(
          key: _formKeyPasswd,
          child: TextFormField(
              onChanged: (value) {
                setState(() => password = value);
                _formKeyPasswd.currentState!.validate();
              },
              validator: (val)=> val!.isEmpty ? "Wprowadź hasło" : null,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
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
          ),
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
          if(_formKeyEmail.currentState!.validate() && _formKeyPasswd.currentState!.validate()){
            dynamic result = await _authentication.logIn(email, password);
            if(result == AppUser.emptyUser){
              setState(() {
                error = "Nieprawidłowe dane";
              });
            }
          }
        },
      ),
    );
  }

  Widget _buildReturnButton(){
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 20,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.58, MediaQuery.of(context).size.height*0.05)
        ),
        child: const Text("Nie posiadasz konta?"),
        onPressed: () {
          widget.changeLogInView();
        },
      ),
    );
  }

  Widget _buildRemindPasswordButton(){
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            textStyle:
            const TextStyle(
              fontSize: 20,
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width*0.58, MediaQuery.of(context).size.height*0.05)
        ),
        child: const Text("Przypomnij hasło"),
        onPressed: () {
          widget.changeLogInView();
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

  Container _buildLogInContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black54
      ),
      width: MediaQuery.of(context).size.width*0.75,
      height: MediaQuery.of(context).size.height*0.33,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      child: Column(
          children: [
            _buildEmailField(),
            _buildPasswordField(),
            _buildLogInButton(),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(error,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red
                ),
              ),
            )
          ],
        ),
    );
  }
}