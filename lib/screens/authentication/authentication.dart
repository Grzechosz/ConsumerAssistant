import 'package:consciousconsumer/screens/authentication/log_in.dart';
import 'package:consciousconsumer/screens/authentication/register.dart';
import 'package:flutter/cupertino.dart';

class Authentication extends StatefulWidget{
  const Authentication({super.key});


  @override
  State<StatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>{
  bool isRegisterPageVisible = false;

  void changeRegisterView(){
    setState(() => isRegisterPageVisible = !isRegisterPageVisible);
  }

  @override
  Widget build(BuildContext context) {
    if(isRegisterPageVisible){
      return Register(changeRegisterView: changeRegisterView);
    }
    return LogIn(changeRegisterView: changeRegisterView);
  }
}