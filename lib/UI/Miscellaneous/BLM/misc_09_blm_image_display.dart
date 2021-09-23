// import 'package:flutter/material.dart';

// class MiscBLMImageDisplayFeedTemplate extends StatelessWidget{
//   final String image;
//   final double backSize;
//   final double frontSize;
//   final Color backgroundColor;
//   const MiscBLMImageDisplayFeedTemplate({Key? key, this.image = 'assets/icons/app-icon.png', this.backSize = 20, this.frontSize = 15, this.backgroundColor = const Color(0xff000000),}) : super(key: key);

//   @override
//   Widget build(BuildContext context){
//     return CircleAvatar(
//       radius: backSize,
//       backgroundColor: backgroundColor,
//       child: CircleAvatar(
//         backgroundImage: const AssetImage('assets/icons/app-icon.png',),
//         backgroundColor: Colors.transparent,
//         foregroundImage: AssetImage(image),
//         radius: frontSize,
//       ),
//     );
//   }
// }