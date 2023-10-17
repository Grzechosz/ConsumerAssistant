import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class LogInButton extends StatelessWidget{
  final Function function;
  const LogInButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
          textStyle:
          const TextStyle(
            fontSize: 25,
            letterSpacing: 0.5
          ),
          backgroundColor: Constants.darkGreen,
          foregroundColor: Colors.white,
          minimumSize: Size(width*0.8,
              height*0.075),
      ),
      child: const Text(Constants.LOG_IN),
      onPressed: () {
        function();
      },
    );
  }
}

class RegisterButton extends StatelessWidget{
  final Function function;
  const RegisterButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: height*0.02),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          textStyle:
          const TextStyle(
              fontSize: 25,
              letterSpacing: 0.5
          ),
          backgroundColor: Constants.darkestGreen,
          foregroundColor: Colors.white,
          minimumSize: Size(width*0.8,
              height*0.075),
        ),
        child: const Text(Constants.REGISTER),
        onPressed: () {
          function();
        },
      ),
    );
  }
}

class RemindPasswordButton extends StatelessWidget{
  final Function function;
  const RemindPasswordButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: height*0.02),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Constants.darkGreen
        ),
        child: const Text("Nie pamiętasz hasła?",
        style: TextStyle(
          fontSize: 17
        ),),
        onPressed: () {
        },
      ),
    );
  }
}

class EmailFieldContainer extends StatelessWidget{
  final formKeyEmail;
  EmailFieldContainer({super.key, required this.formKeyEmail});

  String email='';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width*0.8,
        height: height*0.075,
        // margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Constants.darkGreen50,
                width: 2
            ),
            color: Colors.white
        ),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Form(
          key: formKeyEmail,
          child:
          TextFormField(
              onChanged: (value) {
                email = value;
                formKeyEmail.currentState!.validate();
              },
              validator: (val)=> val!.isEmpty ? "Wprowadź email" : null,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.email,
                    size: 30,
                    color: Constants.darkGreen50,),
                  hintStyle: TextStyle(
                      color: Constants.darkGreen50,
                      fontSize: 20
                  ),
                  hintText: 'Email',
                  border: InputBorder.none
              )
          ),
        )
    );
  }
}

class PasswordFieldContainer extends StatelessWidget{
  final formKeyPasswd;
  PasswordFieldContainer({super.key, required this.formKeyPasswd});

  String password='';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        width: width*0.8,
        height: height*0.075,
        margin: EdgeInsets.only(top: height*0.01, bottom: height*0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Constants.darkGreen50,
                width: 2
            ),
            color: Colors.white
        ),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Form(
          key: formKeyPasswd,
          child: TextFormField(
              onChanged: (value) {
                password = value;
                formKeyPasswd.currentState!.validate();
              },
              validator: (val)=> val!.isEmpty ? "Wprowadź hasło" : null,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    size: 30,
                    color: Constants.darkGreen50,),
                  hintStyle: TextStyle(
                      color: Constants.darkGreen50,
                      fontSize: 20
                  ),
                  hintText: 'Password',
                  border: InputBorder.none
              )
          ),
        )
    );
  }
}

