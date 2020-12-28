import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class MiscBLMImageDisplayTemplate extends StatelessWidget{

  final String image;

  MiscBLMImageDisplayTemplate({this.image = 'assets/icons/blm-image2.png'});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Container(
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(100),
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

class MiscBLMImageDisplayFeedTemplate extends StatelessWidget{

  final String image;
  final double backSize;
  final double frontSize;
  final Color backgroundColor;

  MiscBLMImageDisplayFeedTemplate({
    this.image = 'assets/icons/app-icon.png',
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