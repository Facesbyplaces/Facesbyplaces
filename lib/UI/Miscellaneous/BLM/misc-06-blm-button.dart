import 'package:flutter/material.dart';

class MiscBLMButtonTemplate extends StatelessWidget{
  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function() onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  MiscBLMButtonTemplate({
    this.buttonText = 'Next',
    this.buttonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: const Color(0xffffffff),),
    required this.onPressed,
    required this.width,
    required this.height,
    this.buttonColor = const Color(0xff2F353D),
  });

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(buttonText, style: buttonTextStyle,),
      minWidth: width,
      height: height,
      shape: const StadiumBorder(),
      color: buttonColor,
    );
  }
}

class MiscBLMButtonSignInWithTemplate extends StatelessWidget{
  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function() onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  final String image;
  MiscBLMButtonSignInWithTemplate({
    this.buttonText = '',
    this.buttonTextStyle = const TextStyle(fontSize: 16,fontWeight: FontWeight.w300, color: const Color(0xff000000),),
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
      shape: const StadiumBorder(),
      color: buttonColor,
      child: Row(
        children: [
          Expanded(child: Container(height: 30, child: Image.asset(image),),),

          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.only(left: 5), child: Text(buttonText, style: buttonTextStyle,),),),
        ],
      ),
    );
  }
}