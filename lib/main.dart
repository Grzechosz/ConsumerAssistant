// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:consciousconsumer/navigationBar.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final cameras = await availableCameras();
  // final firstCamera = cameras.first;
  runApp(const ConsciousConsumerApp());
}

class ConsciousConsumerApp extends StatelessWidget {
  const ConsciousConsumerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:ConsciousConsumer(),
      debugShowCheckedModeBanner: false,
    );
  }

}

