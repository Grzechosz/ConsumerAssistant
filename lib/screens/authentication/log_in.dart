import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/screens/authentication/menu_background_widget.dart';
import 'package:consciousconsumer/services/services.dart';
import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/screens/loading.dart';
import 'sign_screen_widgets.dart';

class LogIn extends StatefulWidget {
  final Function changeRegisterView;

  const LogIn({super.key, required this.changeRegisterView});

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {
  bool loading = false;
  String _email = '';

  final AuthenticationService _authentication = AuthenticationService();
  late FirstButton logInButton = FirstButton(
    function: () async {
      if (_formKeyEmail.currentState!.validate() &&
          _formKeyPasswd.currentState!.validate()) {
        setState(() {
          loading = true;
        });
        dynamic result = await _authentication.logIn(
            emailFieldContainer.email, passwordFieldContainer.password);
        if (result == AppUser.emptyUser) {
          setState(() {
            error = "Nieprawidłowe dane";
            loading = false;
          });
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    },
    text: Constants.logIn,
  );

  late EmailFieldContainer emailFieldContainer = EmailFieldContainer(
    _formKeyEmail,
  );
  late PasswordFieldContainer passwordFieldContainer = PasswordFieldContainer(
    formKeyPasswd: _formKeyPasswd,
  );
  late String error = '';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>();

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
                  screenName: "Logowanie",
                ),
                Material(
                  color: Colors.transparent,
                  child: _builtScreenElements(),
                ),
                const Spacer(),
                SecondButton(
                  function: widget.changeRegisterView,
                  text: Constants.register,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 10,
                )
              ],
            ),
          );
  }

  Align _builtScreenElements() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
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
            emailFieldContainer,
            passwordFieldContainer,
            Text(
              error,
              style: const TextStyle(
                  fontSize: Constants.subTitleSize, color: Colors.red),
            ),
            logInButton,
            RemindPasswordButton(function: () {
              _showChangesOnAccountsNeedsAuthenticationDialog(context)
                  .then((value) => _authentication.forgetPassword(_email));
            }), //email
          ],
        ),
      ),
    );
  }

  Future _showChangesOnAccountsNeedsAuthenticationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Wprowadź email'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: const InputDecoration(hintText: "Email"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                      color: Constants.dark, fontSize: Constants.titleSize),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  throw Exception();
                },
              ),
              TextButton(
                child: const Text(
                  'Dalej',
                  style: TextStyle(
                      color: Constants.sea, fontSize: Constants.titleSize),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  _showRemindPasswordDialog(context);
                },
              ),
            ],
          );
        });
  }

  Future _showRemindPasswordDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Instrukcje zostały wysłane na emaila!',
              style: TextStyle(
                fontSize: Constants.headerSize,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Ok',
                  style: TextStyle(
                      color: Constants.dark, fontSize: Constants.titleSize),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
