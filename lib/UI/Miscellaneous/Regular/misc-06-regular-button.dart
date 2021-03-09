import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularButtonTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function() onPressed;
  final double width;
  final double height;
  final Color buttonColor;

  MiscRegularButtonTemplate({
    this.buttonText = 'Next',
    this.buttonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
    required this.onPressed,
    required this.width,
    required this.height,
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

class MiscRegularButtonSignInWithTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function() onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  final String image;

  MiscRegularButtonSignInWithTemplate({
    this.buttonText = '',
    this.buttonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),
    required this.onPressed,
    required this.width,
    required this.height,
    this.buttonColor = const Color(0xff3A559F),
    this.image = 'assets/icons/facebook.png',
  });

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      minWidth: width,
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 30,
              child: Image.asset(image),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(buttonText,
                style: buttonTextStyle,
              ),
            ),
          ),
        ],
      ),
      shape: StadiumBorder(),
      color: buttonColor,
    );
  }
}