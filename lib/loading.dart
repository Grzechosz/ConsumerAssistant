import 'package:consciousconsumer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{
  final bool isReversedColor;
  const Loading({super.key, required this.isReversedColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitChasingDots(
        color: isReversedColor? Constants.sea : Constants.light,
        size: MediaQuery.of(context).size.width/5,
      ),
    );
  }

}