import 'package:flutter/material.dart';

class MiscRegularBackgroundTemplate extends StatelessWidget{

  final AssetImage image;
  final ColorFilter filter;

  const MiscRegularBackgroundTemplate({
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