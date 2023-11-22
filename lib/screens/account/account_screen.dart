import 'package:consciousconsumer/screens/account/account_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';

class AccountScreen extends StatelessWidget{

  static final AuthenticationService _authService = AuthenticationService();

  const AccountScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        const AccountBackgroundWidget(),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildLogOutButton(),
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

}