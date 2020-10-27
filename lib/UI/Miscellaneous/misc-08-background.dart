import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBackgroundTemplate extends StatelessWidget{

  final AssetImage image;
  final ColorFilter filter;
  
  MiscBackgroundTemplate({
    this.image = const AssetImage('assets/icons/background.png'),
    this.filter = const ColorFilter.srgbToLinearGamma(),
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
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