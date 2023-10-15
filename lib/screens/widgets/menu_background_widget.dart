import 'dart:ui';

import 'package:consciousconsumer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuBackgroundWidget extends StatelessWidget{
  const MenuBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundImage(),
        _buildBackgroundBlur()
      ],
    );
  }

  Image _buildBackgroundImage(){
    return Image.asset(Constants.ASSETS_IMAGE + Constants.BACKGROUND_IMAGE,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  BackdropFilter _buildBackgroundBlur(){
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3
      ),
      child: Container(
        decoration: const BoxDecoration(color: Colors.black54),
      ),
    );
  }

}