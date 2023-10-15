import 'package:consciousconsumer/screens/authentication/log_in.dart';
import 'package:consciousconsumer/screens/authentication/log_in_or_Register.dart';
import 'package:consciousconsumer/screens/authentication/register.dart';
import 'package:flutter/cupertino.dart';

class Authentication extends StatefulWidget{
  const Authentication({super.key});


  @override
  State<StatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>{
  bool isRegisterPageVisible = false;
  bool isLogInPageVisible = false;

  void changeSignInView(){
    setState(() => isRegisterPageVisible = !isRegisterPageVisible);
  }

  void changeLogInView(){
    setState(() => isLogInPageVisible = !isLogInPageVisible);
  }

  @override
  Widget build(BuildContext context) {
    if(isLogInPageVisible){
      return LogIn(changeLogInView: changeLogInView);
    }if(isRegisterPageVisible){
      return Register(changeRegisterView: changeSignInView);
    }
    return LogInOrRegister.LogInOrRegister(changeRegisterView: changeSignInView,
        changeLogInView: changeLogInView);
  }

}