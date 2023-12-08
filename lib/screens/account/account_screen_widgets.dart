import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditableFieldContainer extends HookWidget {
  final GlobalKey<FormState> formKey;
  final Function onChange;
  final String value;
  final String valueName;
  final IconData icon;
  final bool isEnable = true;

  const EditableFieldContainer({
    required this.value,
    super.key,
    required this.valueName,
    required this.icon,
    required this.formKey,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final isEnable = useState(false);
    final value = useState("");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        TextButton(
            onPressed: () {
              if (!isEnable.value) {
                _showConfirmationDialog(context, () {
                  isEnable.value = !isEnable.value;
                });
              } else {
                onChange(value.value);
                isEnable.value = !isEnable.value;
              }
            },
            child: const Text(
              "zmień",
              style: TextStyle(
                  color: Constants.sea, fontSize: Constants.titleSize),
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
              key: formKey,
              child: TextFormField(
                  initialValue: value.value,
                  enabled: isEnable.value,
                  onChanged: (result) {
                    value.value = result;
                    formKey.currentState!.validate();
                  },
                  validator: (val) => val!.isEmpty ? "Wprowadź $valueName" : null,
                  decoration: InputDecoration(
                      icon: Icon(
                        icon,
                        size: 25,
                        color: Constants.dark50,
                      ),
                      hintStyle: const TextStyle(
                          color: Constants.dark50,
                          fontSize: Constants.headerSize),
                      hintText: valueName[0] + valueName.substring(1),
                      border: InputBorder.none)),
            ))
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, VoidCallback function) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Na pewno chcesz edytować $valueName?",
              style: const TextStyle(fontSize: Constants.headerSize),
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
                  Constants.editText,
                  style: TextStyle(
                      color: Constants.sea, fontSize: Constants.titleSize),
                ),
                onPressed: () {
                  function();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
