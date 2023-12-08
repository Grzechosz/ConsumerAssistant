import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ManageProductWidget extends StatefulWidget {
  const ManageProductWidget({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  State<StatefulWidget> createState() => ManageProductWidgetState();
}

class ManageProductWidgetState extends State<ManageProductWidget> {
  XFile? image;

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
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
