import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularButtonTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function onPressed;
  final double width;
  final double height;
  final Color buttonColor;

  MiscRegularButtonTemplate({
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