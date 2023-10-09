import 'package:flutter/material.dart';
import 'package:consciousconsumer/navigationBar.dart';

Future<void> main() async {
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

