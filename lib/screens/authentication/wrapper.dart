import 'package:camera/camera.dart';
import 'package:consciousconsumer/models/app_user.dart';
import 'package:consciousconsumer/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication.dart';
import '../navigation_bar.dart';

class Wrapper extends StatelessWidget {
  final CameraDescription firstCamera;

  const Wrapper({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<AppUser>(context);
    if(user == AppUser.emptyUser){
      return const Authentication();
    }
    return ConsciousConsumer(camera: firstCamera);
  }

}