import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscStartImageBlmTemplate extends StatelessWidget{

  final String image;
  
  MiscStartImageBlmTemplate({
    this.image = 'assets/icons/blm-image2.png',
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Container(
      height: 150,
      width: 150,
      color: Color(0xffF4F3EB),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Transform.rotate(
          angle: 25,
          child: Image.asset(image),
        ),
      ),
    );
  }
}