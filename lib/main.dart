import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/authentication/authentication.dart';
import 'package:consciousconsumer/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:consciousconsumer/screens/navigation_bar.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/app_user.dart';
import 'services/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(ConsciousConsumerApp(firstCamera: firstCamera));
}

class ConsciousConsumerApp extends StatelessWidget {

  final CameraDescription firstCamera;
  const ConsciousConsumerApp({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: AuthenticationService().user,
      initialData: AppUser.emptyUser,
      child: MaterialApp(
        home: Wrapper(firstCamera: firstCamera),
      ),
    );
  }

}

