import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularImageDisplayFeedTemplate extends StatelessWidget{

  final String image;
  final double backSize;
  final double frontSize;
  final Color backgroundColor;

  MiscRegularImageDisplayFeedTemplate({
    this.image = 'assets/icons/blm-image5.png',
    this.backSize = 20,
    this.frontSize = 15,
    this.backgroundColor = const Color(0xff000000),
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return CircleAvatar(
      radius: backSize,
      backgroundColor: backgroundColor,
      child: CircleAvatar(
        radius: frontSize,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(image),
      ),
    );
  }
}