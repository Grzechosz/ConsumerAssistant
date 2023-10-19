// import 'dart:ui';
//
// import 'package:consciousconsumer/constants.dart';
// import 'package:consciousconsumer/models/app_user.dart';
// import 'package:consciousconsumer/services/authentication_service.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/menu_background_widget.dart';
//
// class Register extends StatefulWidget {
//   final Function changeRegisterView;
//   const Register({super.key, required this.changeRegisterView});
//
//   @override
//   RegisterState createState() => RegisterState();
// }
//
// class RegisterState extends State<Register> {
//
//   final AuthenticationService _authentication = AuthenticationService();
//   final _formKeyEmail = GlobalKey<FormState>(),
//       _formKeyPasswd = GlobalKey<FormState>();
//
//   late String email,
//               password,
//               error='';
//   @override
//   Scaffold build(BuildContext context) {
//     return Scaffold(
//         body:
//           MenuBackgroundWidget(child: _builtScreenElements(),),
//     );
//   }
//
//   Row _builtScreenElements(){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             _builtAppLogo(),
//             _builtAppName(),
//             _buildRegisterContainer(),
//             _buildReturnButton()
//           ],
//         ),
//       ],
//     );
//   }
//
//   Container _builtAppLogo(){
//     return Container(
//       padding: const EdgeInsets.only(top: 50),
//       child: Image.asset(
//         Constants.ASSETS_IMAGE + Constants.LOGO_IMAGE,
//         height: 100,
//         width: 100,
//         alignment: Alignment.center,
//       ),
//     );
//   }
//
//
//   Container _buildEmailField(){
//     return Container(
//       height: MediaQuery.of(context).size.height*0.07,
//       margin: const EdgeInsets.only(bottom: 15),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: Colors.black38,
//               width: 2
//           ),
//           color: Colors.white
//       ),
//
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       child: Form(
//         key: _formKeyEmail,
//         child: TextFormField(
//             onChanged: (value) {
//               setState(() => email = value);
//               _formKeyEmail.currentState!.validate();
//             },
//             validator: (val)=> val!.isEmpty ? "Wprowadź email" : null,
//             decoration: const InputDecoration(
//                 icon: Icon(
//                   Icons.email,
//                   size: 30,
//                   color: Colors.black26,),
//                 hintStyle: TextStyle(
//                     color: Colors.black26,
//                     fontSize: 20
//                 ),
//                 hintText: 'Email',
//                 border: InputBorder.none
//             )
//         ),
//       )
//     );
//   }
//
//   Widget _buildPasswordField(){
//     return Container(
//         margin: const EdgeInsets.only(bottom: 15),
//         height: MediaQuery.of(context).size.height*0.07,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//                 color: Colors.black38,
//                 width: 2
//             ),
//             color: Colors.white
//         ),
//
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         child: Form(
//           key: _formKeyPasswd,
//           child: TextFormField(
//               onChanged: (value) {
//                 setState(() => password = value);
//                 _formKeyPasswd.currentState!.validate();
//               },
//               validator: (val)=> val!.isEmpty ? "Wprowadź hasło" : null,
//               obscureText: true,
//               enableSuggestions: false,
//               autocorrect: false,
//               decoration: const InputDecoration(
//                   icon: Icon(
//                     Icons.lock,
//                     size: 30,
//                     color: Colors.black26,),
//                   hintStyle: TextStyle(
//                       color: Colors.black26,
//                       fontSize: 20
//                   ),
//                   hintText: 'Password',
//                   border: InputBorder.none
//               )
//           ),
//         )
//     );
//   }
//
//   Widget _buildRegisterButton(){
//     return Container(
//       padding: const EdgeInsets.only(top: 10),
//       height: MediaQuery.of(context).size.height*0.07,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//             textStyle:
//             const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w500
//             ),
//             backgroundColor: const Color(0xFFDDDDDD),
//             foregroundColor: Colors.black,
//             minimumSize: Size(MediaQuery.of(context).size.width*0.45, MediaQuery.of(context).size.height*0.06)
//         ),
//         child: const Text(Constants.REGISTER),
//         onPressed: () async {
//           if(_formKeyEmail.currentState!.validate() && _formKeyPasswd.currentState!.validate()){
//             dynamic result = await _authentication.register(email, password);
//             if(result == AppUser.emptyUser){
//               setState(() {
//                 error = "Wprowadź poprawny email";
//               });
//             }
//           }
//         },
//       ),
//     );
//   }
//
//   Container _builtAppName() {
//     return Container(
//       width: MediaQuery.of(context).size.width*0.9,
//       margin: const EdgeInsets.all(15),
//       child: Center(
//         child: Stack(
//           children: [
//             Text(
//               Constants.APP_NAME,
//               style: TextStyle(
//                 fontWeight: FontWeight.w900,
//                 fontSize: 50,
//                 letterSpacing: 2,
//                 foreground: Paint()
//                   ..style = PaintingStyle.stroke
//                   ..strokeWidth = 6
//                   ..color = Colors.black,
//               ),
//               overflow: TextOverflow.visible,
//               textAlign: TextAlign.center,
//             ),
//             const Text(
//               Constants.APP_NAME,
//               style: TextStyle(
//                 fontWeight: FontWeight.w900,
//                 fontSize: 50,
//                   letterSpacing: 2,
//                 color: Colors.white
//               ),
//               overflow: TextOverflow.visible,
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//       )
//     );
//   }
//
//   Container _buildRegisterContainer() {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.black54
//       ),
//       width: MediaQuery.of(context).size.width*0.75,
//       height: MediaQuery.of(context).size.height*0.33,
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//           children: [
//             _buildEmailField(),
//             _buildPasswordField(),
//             _buildRegisterButton(),
//             Container(
//               margin: const EdgeInsets.only(top: 5),
//               child: Text(error,
//                 style: const TextStyle(
//                     fontSize: 15,
//                     color: Colors.red
//                 ),
//               ),
//             )
//           ],
//         ),
//
//     );
//   }
//
//   Container _buildReturnButton() {
//     return Container(
//       padding: const EdgeInsets.only(top: 10),
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//             textStyle:
//             const TextStyle(
//               fontSize: 20,
//             ),
//             backgroundColor: Colors.black54,
//             foregroundColor: Colors.white,
//             minimumSize: Size(MediaQuery.of(context).size.width*0.5, MediaQuery.of(context).size.height*0.05)
//         ),
//         child: const Text("Posiadam konto"),
//         onPressed: () {
//           widget.changeRegisterView();
//         },
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/screens/widgets/menu_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../widgets/sign_screen_widgets.dart';

class Register extends StatefulWidget {
  final Function changeRegisterView;


  const Register({super.key, required this.changeRegisterView});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final AuthenticationService _authentication = AuthenticationService();
  late FirstButton registerButton = FirstButton(function: () async {
          if(_formKeyEmail.currentState!.validate() && _formKeyPasswd.currentState!.validate()){
            dynamic result = await _authentication.register(emailFieldContainer.email, passwordFieldContainer.password);
            if(result == AppUser.emptyUser){
              setState(() {
                error = "Nieprawidłowe dane";
                });
              }else{
              Navigator.pop(context);
            }
          }
  },
  text: Constants.SIGN_UP,);

  late EmailFieldContainer emailFieldContainer = EmailFieldContainer(formKeyEmail: _formKeyEmail,);
  late PasswordFieldContainer passwordFieldContainer = PasswordFieldContainer(formKeyPasswd: _formKeyPasswd,);
  late String
  error='';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyPasswd = GlobalKey<FormState>();

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body:
      MenuBackgroundWidget(
        screenName: "Rejestracja",
          child: _builtScreenElements()),
    );
  }

  Row _builtScreenElements(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width*0.04, top: MediaQuery.of(context).size.height/20),
                child: const Text("Wprowadź email i hasło",
                  style: TextStyle(
                      fontSize: 22,
                      color: Constants.darker80,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              emailFieldContainer,
              passwordFieldContainer,
              Text(error,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red
                ),
              ),
              RemindPasswordButton(function: widget.changeRegisterView),
              registerButton,
              SecondButton(function: widget.changeRegisterView, text: Constants.SIGN_IN,),
            ],
          ),
        )

      ],
    );
  }
}