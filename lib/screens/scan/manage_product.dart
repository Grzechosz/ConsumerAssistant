import 'package:flutter/material.dart';
import 'package:consciousconsumer/config/constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ManageProductWidget extends HookWidget {
  const ManageProductWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textEditController = useTextEditingController();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Constants.sea80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Dodaj nazwę',
              style: TextStyle(
                  color: Constants.dark, fontSize: Constants.headerSize),
            ),
            //    i zdjęcie
            TextField(
              controller: textEditController,
              style: const TextStyle(
                  color: Constants.dark, fontSize: Constants.headerSize),
              textAlign: TextAlign.center,
              cursorColor: Colors.white, //<-- SEE HERE
            ),
            TextButton(
              child: const Text(
                'Anuluj',
                style: TextStyle(
                    color: Constants.dark, fontSize: Constants.titleSize),
              ),
              onPressed: () {
                Navigator.pop(context, textEditController.text);
              },
            ),
            TextButton(
              child: const Text(
                'Gotowe',
                style: TextStyle(
                    color: Constants.dark, fontSize: Constants.titleSize),
              ),
              onPressed: () {
                if (textEditController.text.isNotEmpty) {
                  Navigator.pop(context, textEditController.text);
                } else {
                  _showEmptyNameDialog(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEmptyNameDialog(BuildContext context) async {
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
