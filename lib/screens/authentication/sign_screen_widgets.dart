import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';

class FirstButton extends StatelessWidget{
  final Function function;
  final String text;
  const FirstButton({super.key, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Constants.sea,
          borderRadius: BorderRadius.all(
              Radius.circular(25)
          )
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          textStyle:
          const TextStyle(
              fontSize: Constants.headerSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5
          ),
          foregroundColor: Constants.light,
          minimumSize: Size(width*0.75,
              height*0.07),
        ),
        child: Text(text),
        onPressed: () {
          function();
        },
      ),
    );
  }
}

class SecondButton extends StatelessWidget{
  final Function function;
  final String text;
  const SecondButton({super.key, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
          color: Constants.dark,
          borderRadius: BorderRadius.all(
              Radius.circular(10)
          )
      ),
      width: width*0.75,
      height: height*0.07,
      margin: EdgeInsets.only(top: height*0.02),

      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          textStyle:
          const TextStyle(
              fontSize: Constants.headerSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5
          ),
          foregroundColor: Colors.white,
          minimumSize: Size(width*0.8,
              height*0.075),
        ),
        child: Text(text),
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
    double height = MediaQuery.of(context).size.height;

    return Container(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Constants.dark
        ),
        child: const Text("Nie pamiętasz hasła?",
        style: TextStyle(
          fontSize: Constants.subTitleSize
        ),),
        onPressed: () {
        },
      ),
    );
  }
}

class EmailFieldContainer extends StatelessWidget{
  final GlobalKey<FormState> formKeyEmail;
  String email = '';
  EmailFieldContainer(this.formKeyEmail, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width*0.8,
        height: height*0.075,
        margin: EdgeInsets.only(top: height*0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Constants.dark50,
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
                    color: Constants.dark50,),
                  hintStyle: TextStyle(
                      color: Constants.dark50,
                      fontSize: Constants.headerSize
                  ),
                  hintText: 'Email',
                  border: InputBorder.none
              )
          ),
        )
    );
  }
}

class NicknameFieldContainer extends StatelessWidget{
  final formKeyNickname;
  NicknameFieldContainer({super.key, required this.formKeyNickname});

  String nickname='';

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
                color: Constants.dark50,
                width: 2
            ),
            color: Colors.white
        ),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Form(
          key: formKeyNickname,
          child:
          TextFormField(
              onChanged: (value) {
                nickname = value;
                formKeyNickname.currentState!.validate();
              },
              validator: (val)=> val!.isEmpty ? "Wprowadź nazwę użytkownika" : null,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.account_box,
                    size: 30,
                    color: Constants.dark50,),
                  hintStyle: TextStyle(
                      color: Constants.dark50,
                      fontSize: Constants.headerSize
                  ),
                  hintText: 'Nazwa użytkownika',
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
                color: Constants.dark50,
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
                    color: Constants.dark50,),
                  hintStyle: TextStyle(
                      color: Constants.dark50,
                      fontSize: Constants.headerSize
                  ),
                  hintText: 'Hasło',
                  border: InputBorder.none
              )
          ),
        )
    );
  }
}

class ConfirmPasswordFieldContainer extends StatelessWidget{
  final formKeyPasswd;
  ConfirmPasswordFieldContainer({super.key, required this.formKeyPasswd});

  String password='';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        width: width*0.8,
        height: height*0.075,
        margin: EdgeInsets.only(bottom: height*0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Constants.dark50,
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
              validator: (val)=> val!.isEmpty ? "Potwierdź hasło" : null,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    size: 30,
                    color: Constants.dark50,),
                  hintStyle: TextStyle(
                      color: Constants.dark50,
                      fontSize: Constants.headerSize
                  ),
                  hintText: 'Potwierdź hasło',
                  border: InputBorder.none
              )
          ),
        )
    );
  }
}
