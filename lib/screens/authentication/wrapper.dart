import 'package:camera/camera.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';
import 'package:consciousconsumer/screens/navigation_bar.dart';

class Wrapper extends StatelessWidget {
  final CameraDescription firstCamera;

  const Wrapper({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<AppUser>(context);
    if(user == AppUser.emptyUser){
      return const Authentication();
    }
    return const ConsciousConsumer();
  }

}