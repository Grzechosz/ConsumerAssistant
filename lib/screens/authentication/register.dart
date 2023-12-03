import 'package:consciousconsumer/screens/loading.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/screens/authentication/menu_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:consciousconsumer/services/notifications_service.dart';
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
  late FirstButton registerButton = FirstButton(
    function: () async {
      if (_formKeyEmail.currentState!.validate() &&
          _formKeyPasswd.currentState!.validate() &&
          _formKeyNickname.currentState!.validate() &&
          _formKeyConfPasswd.currentState!.validate() &&
          passwordFieldContainer.password ==
              confirmPasswordFieldContainer.password) {
        loading = true;
        AppUser result = await _authentication.register(
            emailFieldContainer.email,
            passwordFieldContainer.password,
            nicknameFieldContainer.nickname);
        if (result == AppUser.emptyUser) {
          setState(() {
            error = "Nieprawidłowe dane";
          });
          loading = false;
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    },
    text: Constants.signUp,
  );

  late EmailFieldContainer emailFieldContainer = EmailFieldContainer(
    formKeyEmail: _formKeyEmail,
  );
  late PasswordFieldContainer passwordFieldContainer = PasswordFieldContainer(
    formKeyPasswd: _formKeyPasswd,
  );
  late ConfirmPasswordFieldContainer confirmPasswordFieldContainer =
      ConfirmPasswordFieldContainer(
    formKeyPasswd: _formKeyConfPasswd,
  );
  late NicknameFieldContainer nicknameFieldContainer =
      NicknameFieldContainer(formKeyNickname: _formKeyNickname);
  late String error = '';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>(),
      _formKeyNickname = GlobalKey<FormState>(),
      _formKeyConfPasswd = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            color: Constants.sea,
            child: const Loading(
              isReversedColor: false,
            ),
          )
        : Container(
            color: Constants.light,
            child: Column(
              children: [
                const MenuBackgroundWidget(
                  screenName: "Rejestracja",
                ),
                Material(
                  color: Colors.transparent,
                  child: _builtScreenElements(),
                ),
                const Spacer(),
                SecondButton(
                  function: widget.changeRegisterView,
                  text: Constants.signIn,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 10,
                )
              ],
            ),
          );
  }

  Widget _builtScreenElements() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.04),
                child: const Text(
                  "Wprowadź email i hasło",
                  style: TextStyle(
                      fontSize: Constants.headerSize,
                      color: Constants.darker80,
                      fontWeight: FontWeight.bold),
                ),
              ),
              nicknameFieldContainer,
              emailFieldContainer,
              passwordFieldContainer,
              confirmPasswordFieldContainer,
              Text(
                error,
                style: const TextStyle(
                    fontSize: Constants.subTitleSize, color: Colors.red),
              ),
              registerButton,
            ],
          ),
        ));
  }
}
