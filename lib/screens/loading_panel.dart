import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../config/constants.dart';

class LoaderPanel extends StatelessWidget {
  final bool isReversedColor;

  LoaderPanel({super.key, this.opacity = 0.5,
    this.dismissibles = false, this.color = Colors.black, required this.isReversedColor
  });

  final double opacity;
  final bool dismissibles;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(child: SpinKitChasingDots(
          color: isReversedColor? Constants.sea : Constants.light,
          size: MediaQuery.of(context).size.width/5,
        ),
        ),
      ],
    );
  }
}