import 'package:consciousconsumer/models/enums.dart';
import 'package:consciousconsumer/screens/account/account_background_widget.dart';
import 'package:consciousconsumer/screens/authentication/sign_screen_widgets.dart';
import 'package:consciousconsumer/screens/ingredients/ingredient_description.dart';
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

  final Container spacer = Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    height: 2,
    color: Constants.dark50,
  );

  late EditableEmailFieldContainer emailFieldContainer;
  late EditableNicknameFieldContainer editableNicknameFieldContainer;
  late String error = '';

  final _formKeyEmail = GlobalKey<FormState>(),
      _formKeyNickname = GlobalKey<FormState>();

  AppUser? currentUser;

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
    return SingleChildScrollView(
      child:
      Container(
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
            _builtScreenElements(screenSize),
          ],
        ),
      ),
    );
  }

  void onChangeEmail(String newEmail) {
    AuthenticationService service = AuthenticationService();
    service.updateEmail(newEmail);
  }

  static Widget _buildLogOutButton() {
    return TextButton(
      onPressed: () async {
        await _authService.logOut();
      },
      child: const Row(
        children: [
          Icon(
            Icons.logout,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Wyloguj",
            style: TextStyle(fontSize: Constants.headerSize, color: Colors.red),
          ),
        ],
      ),
    );
  }

  static Widget _buildDeleteAccountButton() {
    return TextButton(
      onPressed: () async {
        await _authService.logOut();
      },
      child: const Row(
        children: [
          Icon(
            Icons.no_accounts,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Usuń konto",
            style: TextStyle(fontSize: Constants.headerSize, color: Colors.red),
          ),
        ],
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
            SizedBox(
              height: screenSize.height / 100,
            ),
            emailFieldContainer,
            RemindPasswordButton(function: ()=>{}),
            Text(
              error,
              style: const TextStyle(
                  fontSize: Constants.subTitleSize, color: Colors.red),
            ),
            spacer,
            _buildEmoticonsLegend(screenSize),
            spacer,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDeleteAccountButton(),
                _buildLogOutButton(),
              ],
            )
          ],
        ),
    );
  }

  Container _buildEmoticonsLegend(Size screenSize){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width/20),
      child: Column(
        children: [
          _harmfulnessLegendRow(Harmfulness.good, screenSize.width/8),
          _harmfulnessLegendRow(Harmfulness.harmful, screenSize.width/8),
          _harmfulnessLegendRow(Harmfulness.dangerous, screenSize.width/8),
          _harmfulnessLegendRow(Harmfulness.uncharted, screenSize.width/8),
        ],
      )
    );
  }

  Container _harmfulnessLegendRow(Harmfulness harmfulness, double iconSize){
    return Container(
      margin: EdgeInsets.symmetric(vertical: iconSize/10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getHarmfulnessImage(harmfulness, iconSize),
          Text(
            IngredientDescription.harmfulnessToString(harmfulness),
            style: const TextStyle(
                fontSize: Constants.headerSize
            ),
          )],
      ),
    );

  }

  static Image getHarmfulnessImage(Harmfulness harmfulness, double size){
    String icon;
    switch(harmfulness){
      case Harmfulness.good:
        icon = Constants.assetsHarmfulnessIcons + Constants.goodIcon;
        break;
      case Harmfulness.harmful:
        icon = Constants.assetsHarmfulnessIcons + Constants.harmfulIcon;
        break;
      case Harmfulness.dangerous:
        icon = Constants.assetsHarmfulnessIcons + Constants.dangerousIcon;
        break;
      case Harmfulness.uncharted:
        icon = Constants.assetsHarmfulnessIcons + Constants.unchartedIcon;
        break;
    }
    return Image.asset(icon, height: size,);
  }

  void onChangeNickname(String nickname) {
    AuthenticationService service = AuthenticationService();
    service.updateName(nickname);
  }
}
