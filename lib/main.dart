import 'package:camera/camera.dart';
import 'package:consciousconsumer/screens/authentication/wrapper.dart';
import 'package:consciousconsumer/services/notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/firebase_options.dart';
import 'models/app_user.dart';
import 'services/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(ConsciousConsumerApp(firstCamera: firstCamera)));
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
        debugShowCheckedModeBanner: false,
        home: Wrapper(firstCamera: firstCamera),
      ),
    );
  }

}

