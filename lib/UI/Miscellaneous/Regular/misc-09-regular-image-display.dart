import 'package:flutter/material.dart';

class MiscRegularImageDisplayFeedTemplate extends StatelessWidget{

  final String image;
  final double backSize;
  final double frontSize;
  final Color backgroundColor;

  const MiscRegularImageDisplayFeedTemplate({
    this.image = 'assets/icons/app-icon.png',
    this.backSize = 20,
    this.frontSize = 15,
    this.backgroundColor = const Color(0xff000000),
  });

  @override
  Widget build(BuildContext context){
    return CircleAvatar(
      radius: backSize,
      backgroundColor: backgroundColor,
      child: CircleAvatar(
        radius: frontSize,
        backgroundColor: Colors.transparent,
        foregroundImage: AssetImage(image),
        backgroundImage: const AssetImage('assets/icons/app-icon.png'),
      ),
    );
  }
}