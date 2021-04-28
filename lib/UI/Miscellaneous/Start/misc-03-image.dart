import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscStartImageTemplate extends StatelessWidget{

  final String image;
  
  MiscStartImageTemplate({
    this.image = 'assets/icons/frontpage-image3.png',
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Container(
      padding: EdgeInsets.all(5),
      color: Color(0xffffffff),
      height: 100,
      width: 100,
      child: Image.asset(image),
    );
  }
}