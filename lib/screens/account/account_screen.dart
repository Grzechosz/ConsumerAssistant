import 'package:consciousconsumer/screens/account/account_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../authentication/sign_screen_widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{
  static final AuthenticationService _authService = AuthenticationService();

  late EmailFieldContainer emailFieldContainer = EmailFieldContainer(formKeyEmail: _formKeyEmail,);
  late PasswordFieldContainer passwordFieldContainer = PasswordFieldContainer(formKeyPasswd: _formKeyPasswd,);
  late String
  error='';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        const AccountBackgroundWidget(),
        Align(
          alignment: Alignment.bottomRight,
          child: _builtScreenElements(context),
        )
      ]
    );
  }

  static Widget _buildLogOutButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20, right: 20),
      color: Constants.light,
      child: TextButton(
        onPressed: () async{
          await _authService.logOut();
        },
        child: const Text(
            "Wyloguj",
          style: TextStyle(
            fontSize: 25,
            color: Colors.red
          ),
        ),
      ),
    );
  }

  Row _builtScreenElements(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SingleChildScrollView(
        //   physics: const NeverScrollableScrollPhysics(),
        //   padding: EdgeInsets.only(top: MediaQuery.of(context)
        //       .size.height/3),
          Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(),
              emailFieldContainer,
              passwordFieldContainer,
              Text(error,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red
                ),
              ),
              _buildLogOutButton(),
            ],
          ),
        )
      ],
    );
  }

}