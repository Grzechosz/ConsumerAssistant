import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';

class EditableEmailFieldContainer extends StatefulWidget {
  final GlobalKey<FormState> formKeyEmail;
  final Function onChangeEmail;
  String email;
  bool isEnable = true;

  EditableEmailFieldContainer(this.email, {super.key, required this.formKeyEmail, required this.onChangeEmail});
  void changeEnable() {
    isEnable = !isEnable;
  }

  @override
  State<StatefulWidget> createState() => _EditableEmailFieldContainerState();
}

class _EditableEmailFieldContainerState extends State<EditableEmailFieldContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        TextButton(
          onPressed: () => setState(() {
            if(!widget.isEnable) {
              _showConfirmationDialog();
            }else{
              widget.onChangeEmail(widget.email);
              widget.changeEnable();
            }
          }),
          child: const Text(
            "zmień",
            style: TextStyle(color: Constants.sea,
                fontSize: Constants.titleSize),
          )),
        Container(
            width: width * 0.8,
            height: height * 0.075,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Constants.dark50, width: 2),
                color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Form(
              key: widget.formKeyEmail,
              child: TextFormField(
                  initialValue: widget.email,
                  enabled: widget.isEnable,
                  onChanged: (value) {
                    widget.email = value;
                    widget.formKeyEmail.currentState!.validate();
                  },
                  validator: (val) => val!.isEmpty ? "Wprowadź email" : null,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.email,
                        size: 25,
                        color: Constants.dark50,
                      ),
                      hintStyle: TextStyle(
                          color: Constants.dark50, fontSize: Constants.headerSize),
                      hintText: 'Email',
                      border: InputBorder.none)),
            ))
      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Na pewno chcesz edytować email?",
              style: TextStyle(
                  fontSize: Constants.headerSize
              ),),
            actions: [
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                      color: Constants.dark,
                      fontSize: Constants.titleSize
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  Constants.editText,
                  style: TextStyle(
                      color: Constants.sea,
                      fontSize: Constants.titleSize
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.changeEnable();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

class EditableNicknameFieldContainer extends StatefulWidget {
  final GlobalKey<FormState> formKeyNickname;
  final Function onChangeNickname;
  String nickname;
  bool isEnable = true;

  EditableNicknameFieldContainer(this.nickname, {super.key, required this.formKeyNickname, required this.onChangeNickname});
  void changeEnable() {
    isEnable = !isEnable;
  }

  @override
  State<StatefulWidget> createState() => _EditableNicknameFieldContainerState();
}

class _EditableNicknameFieldContainerState extends State<EditableNicknameFieldContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        TextButton(
            onPressed: () => setState(() {
              if(!widget.isEnable) {
                _showConfirmationDialog();
              }else{
                widget.onChangeNickname(widget.nickname);
                widget.changeEnable();
              }
            }),
            child: const Text(
              "zmień",
              style: TextStyle(color: Constants.sea,
                  fontSize: Constants.titleSize),
            )),
        Container(
            width: width * 0.8,
            height: height * 0.075,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Constants.dark50, width: 2),
                color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Form(
              key: widget.formKeyNickname,
              child: TextFormField(
                  initialValue: widget.nickname,
                  enabled: widget.isEnable,
                  onChanged: (value) {
                    widget.nickname = value;
                    widget.formKeyNickname.currentState!.validate();
                  },
                  validator: (val) => val!.isEmpty ? "Wprowadź nazwę użytkownika" : null,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.account_box,
                        size: 25,
                        color: Constants.dark50,
                      ),
                      hintStyle: TextStyle(
                          color: Constants.dark50, fontSize: Constants.headerSize),
                      hintText: 'Email',
                      border: InputBorder.none)),
            ))
      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Na pewno chcesz edytować nazwę użytkownika?",
              style: TextStyle(
                  fontSize: Constants.headerSize
              ),),
            actions: [
              TextButton(
                child: const Text(
                  Constants.cancelText,
                  style: TextStyle(
                      color: Constants.dark,
                      fontSize: Constants.titleSize
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  Constants.editText,
                  style: TextStyle(
                      color: Constants.sea,
                      fontSize: Constants.titleSize
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.changeEnable();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}