import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:consciousconsumer/navigationBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(ConsciousConsumerApp(firstCamera: firstCamera));
}

class ConsciousConsumerApp extends StatelessWidget {

  final CameraDescription firstCamera;
  const ConsciousConsumerApp({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:ConsciousConsumer(camera: firstCamera),
      debugShowCheckedModeBanner: false,
    );
  }

}

