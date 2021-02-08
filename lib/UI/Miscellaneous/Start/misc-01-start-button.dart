import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiscStartButtonIconTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  final Color backgroundColor;
  final Widget image;

  MiscStartButtonIconTemplate({
    this.buttonText = '',
    this.buttonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),
    this.onPressed,
    this.width,
    this.height,
    this.buttonColor = const Color(0xff2F353D),
    this.backgroundColor = const Color(0xff000000),
    this.image,
  });

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      minWidth: width,
      height: height,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          ScreenUtil.init(
            context: _,
            constraints: constraints,
            designSize: Size(SizeConfig.screenWidth, SizeConfig.screenHeight),
            allowFontScaling: true,
          );
          return Row(
            children: [
              CircleAvatar(
                minRadius: 35.r,
                backgroundColor: backgroundColor,
                child: Center(child: image,),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                  alignment: Alignment.centerLeft,
                  child: Text(buttonText,
                    style: buttonTextStyle
                  ),
                ),
              ),
            ],
          );
        }
      ),
      // child: 
      shape: StadiumBorder(),
      color: buttonColor,
    );
  }
}


class MiscStartButtonTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function onPressed;
  final double width;
  final double height;
  final Color buttonColor;

  MiscStartButtonTemplate({
    this.buttonText = 'Next',
    this.buttonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
    this.onPressed,
    this.width,
    this.height,
    this.buttonColor = const Color(0xff04ECFF),
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(buttonText,
        style: buttonTextStyle,
      ),
      minWidth: width,
      height: height,
      shape: StadiumBorder(),
      color: buttonColor,
    );
  }
}
