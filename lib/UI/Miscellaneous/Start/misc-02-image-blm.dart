// ignore_for_file: file_names
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscStartImageBlmTemplate extends StatelessWidget{
  final String image;
  const MiscStartImageBlmTemplate({this.image = 'assets/icons/blm-image2.png',});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Container(
      color: const Color(0xffF4F3EB),
      height: 150,
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Transform.rotate(
          child: Image.asset(image),
          angle: 25,
        ),
      ),
    );
  }
}