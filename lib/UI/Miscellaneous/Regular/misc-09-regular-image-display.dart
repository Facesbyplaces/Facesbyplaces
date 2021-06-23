import 'package:flutter/material.dart';

class MiscRegularImageDisplayFeedTemplate extends StatelessWidget{
  final String image;
  final double backSize;
  final double frontSize;
  final Color backgroundColor;
  const MiscRegularImageDisplayFeedTemplate({this.image = 'assets/icons/app-icon.png', this.backSize = 20, this.frontSize = 15, this.backgroundColor = const Color(0xff000000),});

  @override
  Widget build(BuildContext context){
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: backSize,
      child: CircleAvatar(
        backgroundImage: const AssetImage('assets/icons/app-icon.png'),
        backgroundColor: Colors.transparent,
        foregroundImage: AssetImage(image),
        radius: frontSize,
      ),
    );
  }
}