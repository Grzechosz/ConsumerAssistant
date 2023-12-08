import 'package:consciousconsumer/screens/account/account_background_widget.dart';
import 'package:consciousconsumer/screens/authentication/sign_screen_widgets.dart';
import 'package:consciousconsumer/screens/ingredients/ingredient_description.dart';
import 'package:consciousconsumer/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:consciousconsumer/models/models.dart';
import 'account_screen_widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static final AuthenticationService _authService = AuthenticationService();
  String _password = '';

  final Container spacer = Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    height: 2,
    color: Constants.dark50,
  );

  late EditableFieldContainer emailFieldContainer;
  late EditableFieldContainer editableNicknameFieldContainer;
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

    emailFieldContainer = EditableFieldContainer(
      value: currentUser!.email,
      valueName: 'email',
      icon: Icons.email,
      formKey: _formKeyEmail, onChange: onChangeEmail,
    );
    editableNicknameFieldContainer = EditableFieldContainer(
        value: currentUser!.name,
        formKey: _formKeyNickname,
        onChange: onChangeNickname,
      valueName: 'nazwa użytkownika',
      icon: Icons.account_circle,);

    int timeToDeleteAccount =
        7+currentUser!.createdAccountDate.difference(DateTime.now()).inDays;
    return SingleChildScrollView(
      child: Container(
        color: Constants.light,
        child: Column(
          children: [
            AccountBackgroundWidget(
              authService: _authService,
            ),
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
    try {
      _authService.updateEmail(newEmail);
    } catch (ex) {
      _showChangesOnAccountsNeedsAuthenticationDialog(context).then((value) {
        _authService.updateEmail(newEmail);
      });
    }
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

  Widget _buildDeleteAccountButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        _showDeleteAccountConfirmationDialog(context);
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

  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Na pewno chcesz usunąć konto? Ta czynność jest nieodwracalna!",
              style:
                  TextStyle(fontSize: Constants.headerSize, color: Colors.red),
            ),
            actions: [
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                      color: Constants.dark, fontSize: Constants.titleSize),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  Constants.deleteText,
                  style: TextStyle(
                      color: Constants.sea, fontSize: Constants.titleSize),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  try{
                    _authService.deleteAccount(context);
                  }catch(e){
                    await _showChangesOnAccountsNeedsAuthenticationDialog(context)
                        .then((value) {
                      _authService.deleteAccount(context);
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  Future _showChangesOnAccountsNeedsAuthenticationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Wprowadź hasło'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: "hasło"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                      color: Constants.dark, fontSize: Constants.titleSize),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  throw Exception();
                },
              ),
              TextButton(
                child: const Text(
                  'Dalej',
                  style: TextStyle(
                      color: Constants.sea, fontSize: Constants.titleSize),
                ),
                onPressed: () async {
                  dynamic result = await _authService.reAuthorization(
                      currentUser!.email, _password);
                  if (result == AppUser.emptyUser) {
                    Navigator.pop(context);
                    _showBadPasswordDialog(context);
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  Future _showBadPasswordDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(content: Text('Nieprawidłowe hasło!'));
        });
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
          RemindPasswordButton(function: () => {}),
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
              _buildDeleteAccountButton(context),
              _buildLogOutButton(),
            ],
          )
        ],
      ),
    );
  }

  Container _buildEmoticonsLegend(Size screenSize) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: screenSize.width / 20),
        child: Column(
          children: [
            _harmfulnessLegendRow(Harmfulness.good, screenSize.width / 8),
            _harmfulnessLegendRow(Harmfulness.harmful, screenSize.width / 8),
            _harmfulnessLegendRow(Harmfulness.dangerous, screenSize.width / 8),
            _harmfulnessLegendRow(Harmfulness.uncharted, screenSize.width / 8),
          ],
        ));
  }

  Container _harmfulnessLegendRow(Harmfulness harmfulness, double iconSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: iconSize / 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getHarmfulnessImage(harmfulness, iconSize),
          Text(
            IngredientDescription.harmfulnessToString(harmfulness),
            style: const TextStyle(fontSize: Constants.headerSize),
          )
        ],
      ),
    );
  }

  static Image getHarmfulnessImage(Harmfulness harmfulness, double size) {
    String icon;
    switch (harmfulness) {
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
    return Image.asset(
      icon,
      height: size,
    );
  }

  void onChangeNickname(String nickname) {
    try{
      _authService.updateName(nickname);
    }catch(e){
      _showChangesOnAccountsNeedsAuthenticationDialog(context).then((value) {
        _authService.updateName(nickname);
      });
    }
  }
}
