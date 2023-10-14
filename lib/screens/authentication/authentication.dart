import 'package:consciousconsumer/screens/authentication/sign_in.dart';
import 'package:flutter/cupertino.dart';

class Authentication extends StatefulWidget{
  const Authentication({super.key});


  @override
  State<StatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }

}