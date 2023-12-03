import 'package:consciousconsumer/screens/account/account_background_widget.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../models/app_user.dart';
import 'account_screen_widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static final AuthenticationService _authService = AuthenticationService();

  late EditableEmailFieldContainer emailFieldContainer;
  late String error = '';

  final _formKeyEmail = GlobalKey<FormState>();

  AppUser? currentUser;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    currentUser = Provider.of<AppUser>(context);
    emailFieldContainer = EditableEmailFieldContainer(
        currentUser!.email, formKeyEmail: _formKeyEmail, onChangeEmail: onChangeEmail,);
    emailFieldContainer.changeEnable();
    int timeToDeleteAccount =
        7 - currentUser!.createdAccountData.difference(DateTime.now()).inDays;
    emailFieldContainer.email = currentUser!.email;
    return Container(
      color: Constants.light,
      child: Column(
        children: [
          const AccountBackgroundWidget(),
          Text(
            currentUser!.isEmailVerified
                ? ''
                : 'Twój email nie został potwierdzony!',
            style: const TextStyle(
                color: Colors.red, fontSize: Constants.titleSize),
          ),
          Text(
            currentUser!.isEmailVerified
                ? ''
                : 'Po upływie czasu konto zostanie usunięte: $timeToDeleteAccount dni',
            style: const TextStyle(
                color: Colors.red, fontSize: Constants.titleSize),
          ),
          Material(
            color: Colors.transparent,
            child: _builtScreenElements(context),
          ),
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.width / 10,
          )
        ],
      ),
    );
  }

  void onChangeEmail(String newEmail){
    AuthenticationService service = AuthenticationService();
    service.updateEmail(newEmail);
  }

  static Widget _buildLogOutButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20, right: 20),
      color: Constants.light,
      child: TextButton(
        onPressed: () async {
          await _authService.logOut();
        },
        child: const Text(
          "Wyloguj",
          style: TextStyle(fontSize: 25, color: Colors.red),
        ),
      ),
    );
  }

  Widget _builtScreenElements(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            emailFieldContainer,
            Text(
              error,
              style: const TextStyle(
                  fontSize: Constants.subTitleSize, color: Colors.red),
            ),
            _buildLogOutButton(),
          ],
        ),
      ),
    );
  }
}
