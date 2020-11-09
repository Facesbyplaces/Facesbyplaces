import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscButtonTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function onPressed;
  final double width;
  final double height;
  final Color buttonColor;

  MiscButtonTemplate({
    this.buttonText = 'Next',
    this.buttonTextStyle = const TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Color(0xffffffff),),
    this.onPressed,
    this.width,
    this.height,
    this.buttonColor = const Color(0xff2F353D),
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

class MiscButtonIconTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  final Color backgroundColor;
  final Widget image;

  MiscButtonIconTemplate({
    this.buttonText = '',
    this.buttonTextStyle = const TextStyle(fontSize: 16,fontWeight: FontWeight.w300, color: Color(0xff000000),),
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
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              radius: SizeConfig.blockSizeVertical * 4.5,
              backgroundColor: backgroundColor,
              child: Center(child: image,),
            ),
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
      ),
      shape: StadiumBorder(),
      color: buttonColor,
    );
  }
}


class MiscButtonSignInWithTemplate extends StatelessWidget{

  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  final String image;

  MiscButtonSignInWithTemplate({
    this.buttonText = '',
    this.buttonTextStyle = const TextStyle(fontSize: 16,fontWeight: FontWeight.w300, color: Color(0xff000000),),
    this.onPressed,
    this.width,
    this.height,
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
              height: SizeConfig.blockSizeVertical * 4, 
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