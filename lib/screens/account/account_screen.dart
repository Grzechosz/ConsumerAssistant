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
  late EditableNicknameFieldContainer editableNicknameFieldContainer;
  late String error = '';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyNickname = GlobalKey<FormState>();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    currentUser = Provider.of<AppUser>(context);
    emailFieldContainer = EditableEmailFieldContainer(
      currentUser!.email,
      formKeyEmail: _formKeyEmail,
      onChangeEmail: onChangeEmail,
    );
    editableNicknameFieldContainer = EditableNicknameFieldContainer(
        currentUser!.name,
        formKeyNickname: _formKeyNickname,
        onChangeNickname: onChangeNickname);
    emailFieldContainer.changeEnable();
    editableNicknameFieldContainer.changeEnable();
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
          const Spacer(),
          _builtScreenElements(screenSize),
        ],
      ),
    );
  }

  void onChangeEmail(String newEmail) {
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
          style: TextStyle(fontSize: Constants.headerSize, color: Colors.red),
        ),
      ),
    );
  }

  Widget _builtScreenElements(Size screenSize) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            editableNicknameFieldContainer,
            SizedBox(height: screenSize.height/100,),
            emailFieldContainer,
            Text(
              error,
              style: const TextStyle(
                  fontSize: Constants.subTitleSize, color: Colors.red),
            ),
            _buildLogOutButton(),
          ],
        ),
    );
  }

  void onChangeNickname(String nickname) {
    AuthenticationService service = AuthenticationService();
    service.updateName(nickname);
  }
}
