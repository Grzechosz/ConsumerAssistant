import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:consciousconsumer/config/constants.dart';

class ManageProductWidget extends StatefulWidget {
  const ManageProductWidget({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  State<StatefulWidget> createState() => ManageProductWidgetState();
}

class ManageProductWidgetState extends State<ManageProductWidget> {
  XFile? image;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Dodaj nazwę'), //    i zdjęcie
          TextField(
            controller: widget.textEditingController,
          ),
          TextButton(
            child: const Text('Anuluj'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text('Gotowe'),
            onPressed: () {
              if (widget.textEditingController.text.isNotEmpty) {
                Navigator.pop(context, true);
              } else {
                _showEmptyNameDialog();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEmptyNameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Brak nazwy produktu'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Nie wpisano nazwy produktu. Uzupełnij nazwę aby móc zapisać produkt'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok', style: TextStyle(color: Constants.sea)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
