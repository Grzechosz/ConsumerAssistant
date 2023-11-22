
import 'package:consciousconsumer/screens/loading.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/screens/authentication/menu_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import 'sign_screen_widgets.dart';


class Register extends StatefulWidget {
  final Function changeRegisterView;


  const Register({super.key, required this.changeRegisterView});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  bool loading = false;
  final AuthenticationService _authentication = AuthenticationService();
  late FirstButton registerButton = FirstButton(function: () async {
          if(_formKeyEmail.currentState!.validate() && _formKeyPasswd.currentState!.validate()){
            loading = true;
            dynamic result = await _authentication.register(emailFieldContainer.email, passwordFieldContainer.password);
            if(result == AppUser.emptyUser){
              setState(() {
                error = "Nieprawidłowe dane";
                });
              loading = false;
              }else{
              Navigator.pop(context);
            }
          }
  },
  text: Constants.signUp,);

  late EmailFieldContainer emailFieldContainer = EmailFieldContainer(formKeyEmail: _formKeyEmail,);
  late PasswordFieldContainer passwordFieldContainer = PasswordFieldContainer(formKeyPasswd: _formKeyPasswd,);
  late String
  error='';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading(isReversedColor: false,) : Scaffold(
      body:
      MenuBackgroundWidget(
        screenName: "Rejestracja",
          child: _builtScreenElements()),
    );
  }

  Row _builtScreenElements(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width*0.04, top: MediaQuery.of(context).size.height/20),
                child: const Text("Wprowadź email i hasło",
                  style: TextStyle(
                      fontSize: 22,
                      color: Constants.darker80,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              emailFieldContainer,
              passwordFieldContainer,
              Text(error,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red
                ),
              ),
              RemindPasswordButton(function: widget.changeRegisterView),
              registerButton,
              SecondButton(function: widget.changeRegisterView, text: Constants.signIn,),
            ],
          ),
        )

      ],
    );
  }
}