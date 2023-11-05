import 'package:consciousconsumer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.light,
      child: Center(
        child: SpinKitChasingDots(
          color: Constants.sea,
          size: MediaQuery.of(context).size.width/5,
        ),
      ),
    );
  }

}