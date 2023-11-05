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
      if(isRegisterPageVisible) {
        Navigator.push(context,
          PageRouteBuilder(pageBuilder: (q,w,e) => Register(
              changeRegisterView: changeRegisterView),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  SlideTransition(
                    position: Tween(
                      begin: const Offset(-1.0, 0.0),
                      end: const Offset(0.0, 0.0),)
                        .animate(animation),
                    child: child,
                  ))
      );
      }else{
        Navigator.pop(context);
      }
  }

  @override
  Widget build(BuildContext context) {
    return LogIn(changeRegisterView: changeRegisterView);
  }
}