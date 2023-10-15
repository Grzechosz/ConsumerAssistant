import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget{

  static final AuthenticationService _authService = AuthenticationService();

  const AccountScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildLogOutButton()],
    );
  }


  static Widget _buildLogOutButton() {
    return Container(
      child: Container(
        child: ElevatedButton(
          onPressed: () async{
            await _authService.logOut();
          },
          child: const Text("Wyloguj",
          style: TextStyle(
            height: 5
          ),),
        ),
      ),
    );
  }

}