import 'package:flutter/material.dart';

class MiscRegularBackgroundTemplate extends StatelessWidget{
  final AssetImage image;
  final ColorFilter filter;
  const MiscRegularBackgroundTemplate({Key? key, this.image = const AssetImage('assets/icons/background.png'), this.filter = const ColorFilter.srgbToLinearGamma(),}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: filter,
          fit: BoxFit.cover,
          image: image,
        ),
      ),
    );
  }
}