import 'package:flutter/material.dart';


class ProductPhotoWidget extends StatefulWidget{
  const ProductPhotoWidget({super.key});


  @override
  State<StatefulWidget> createState() => ProductPhotoWidgetState();
}

class ProductPhotoWidgetState extends State<ProductPhotoWidget> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:
      // FutureBuilder<void>(
      //     future: ,
      //     builder: (context, snapshot) {
      //       return (snapshot.connectionState == ConnectionState.done
      //           ? CameraPreview(widget.cameraController)
      //           : const Loading(isReversedColor: true));
      //     }),
      Text('Dodaj nazwę i zdjęcie'),
      // CameraPreview(widget.cameraController),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed:_takePicture,
      //   backgroundColor: Constants.sea,
      //   child: const Icon(
      //     Icons.camera_alt,
      //   ),
      // ),
    );
  }



}