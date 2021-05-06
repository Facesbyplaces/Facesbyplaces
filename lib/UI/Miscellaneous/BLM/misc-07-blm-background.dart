import 'package:flutter/material.dart';

class MiscBLMBackgroundTemplate extends StatelessWidget{

  final AssetImage image;
  final ColorFilter filter;
  
  const MiscBLMBackgroundTemplate({
    this.image = const AssetImage('assets/icons/background.png'),
    this.filter = const ColorFilter.srgbToLinearGamma(),
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
          colorFilter: filter,
        ),
      ),
    );
  }
}