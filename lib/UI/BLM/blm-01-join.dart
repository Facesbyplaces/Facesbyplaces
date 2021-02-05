// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:flutter/material.dart';

// class BLMJoin extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
//     return Scaffold(
//       body: Stack(
//         children: [

//           MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

//           ContainerResponsive(
//             height: SizeConfig.screenHeight,
//             width: SizeConfig.screenWidth,
//             alignment: Alignment.center,
//             child: ContainerResponsive(
//               padding: EdgeInsetsResponsive.only(left: 10.0, right: 10.0),
//               width: SizeConfig.screenWidth,
//               heightResponsive: false,
//               widthResponsive: true,
//               alignment: Alignment.center,
//               child: SingleChildScrollView(
//                 physics: ClampingScrollPhysics(),
//                 padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                 child: Column(
//                   children: [

//                     SizedBox(height: ScreenUtil().setHeight(10)),

//                     Align(
//                       alignment: Alignment.centerLeft, 
//                       child: IconButton(
//                         onPressed: (){
//                           Navigator.pop(context);
//                         }, 
//                         icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: ScreenUtil().setHeight(30),),
//                       ),
//                     ),

//                     SizedBox(height: ScreenUtil().setHeight(10)),

//                     Container(
//                       height: ScreenUtil().setHeight(45),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Center(
//                               child: Text('BLACK',
//                                 style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               child: Text('LIVES',
//                                 style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xffffffff),
//                                 ),
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Color(0xff000000),
//                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text('MATTER',
//                                 style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: ScreenUtil().setHeight(50)),

//                     ContainerResponsive(
//                       width: SizeConfig.screenWidth,
//                       height: SizeConfig.screenHeight / 2,
//                       heightResponsive: false,
//                       widthResponsive: true,
//                       child: Stack(
//                         children: [
//                           Transform.rotate(angle: 75, child: MiscBLMImageDisplayTemplate(),),

//                           Positioned(left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                           Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                           Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                           Positioned(top: SizeConfig.blockSizeHorizontal * 25, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                           Positioned(top: SizeConfig.blockSizeHorizontal * 25, right: 0, child: MiscBLMImageDisplayTemplate(),),

//                           Positioned(bottom: 0, left: 0, child: Transform.rotate(angle: 0, child: MiscBLMImageDisplayTemplate(),),),

//                           Positioned(bottom: 0, left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                           Positioned(right: 10, bottom: 0, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                           Center(child: Image.asset('assets/icons/logo.png', height: ScreenUtil().setHeight(150), width: ScreenUtil().setWidth(150),),),
                          
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: ScreenUtil().setHeight(25)),

//                     Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                
//                     MiscBLMButtonTemplate(
//                       buttonText: 'Join', 
//                       buttonTextStyle: TextStyle(
//                         fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
//                         fontWeight: FontWeight.bold, 
//                         color: Color(0xffffffff),
//                       ), 
//                       onPressed: (){
//                         Navigator.pushNamed(context, '/blm/login');
//                       }, 
//                       width: SizeConfig.screenWidth / 2, 
//                       height: ScreenUtil().setHeight(45),
//                       buttonColor: Color(0xff4EC9D4),
//                     ),

//                     SizedBox(height: ScreenUtil().setHeight(10)),

//                   ],
//                 ),
//               ),
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }
// }




// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BLMJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // ResponsiveWidgets.init(context,
    //   height: SizeConfig.screenHeight,
    //   width: SizeConfig.screenWidth,
    // );
    return Scaffold(
      body: ResponsiveWrapper(
        maxWidth: SizeConfig.screenWidth,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
        child: Container(
          height: SizeConfig.screenHeight,
          child: Center(
          ),

          // child: Stack(
          //   children: [

          //     MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          //     Padding(
          //       padding: EdgeInsets.only(left: 20.0, right: 20.0),
          //       child: Column(
          //       children: [

          //         // SizedBox(height: ScreenUtil().setHeight(10)),
          //         // SizedBox(height: 10),
          //         SizedBox(height: 30),

          //         Align(
          //           alignment: Alignment.centerLeft, 
          //           child: IconButton(
          //             onPressed: (){
          //               Navigator.pop(context);
          //             }, 
          //             icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: 30),
          //           ),
          //         ),

          //         // SizedBox(height: ScreenUtil().setHeight(10)),
          //         SizedBox(height: 10),

          //         Container(
          //           // height: ScreenUtil().setHeight(45),
          //           // height: 340,
          //           color: Colors.blue,
          //           height: 45,
          //           // height: 100,
          //           // constraints: BoxConstraints.loose(),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: Center(
          //                   child: Text('BLACK',
          //                     style: TextStyle(
          //                       // fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
          //                       fontSize: 24,
          //                       fontWeight: FontWeight.bold,
          //                       color: Color(0xff000000),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Container(
          //                   alignment: Alignment.center,
          //                   child: Text('LIVES',
          //                     style: TextStyle(
          //                       // fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
          //                       fontSize: 24,
          //                       fontWeight: FontWeight.bold,
          //                       color: Color(0xffffffff),
          //                     ),
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color: Color(0xff000000),
          //                     borderRadius: BorderRadius.all(Radius.circular(10)),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Center(
          //                   child: Text('MATTER',
          //                     style: TextStyle(
          //                       // fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
          //                       fontSize: 24,
          //                       fontWeight: FontWeight.bold,
          //                       color: Color(0xff000000),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),

          //         // SizedBox(height: ScreenUtil().setHeight(50)),
          //         SizedBox(height: 50,),

          //         // ContainerResponsive(
          //         //   width: SizeConfig.screenWidth,
          //         //   height: SizeConfig.screenHeight / 2,
          //         //   heightResponsive: false,
          //         //   widthResponsive: true,
          //         //   child: 
          //         // ),
          //         Container(
          //           color: Colors.red,
          //           // height: SizeConfig.screenHeight / 2,
          //           // height: SizeConfig.screenHeight / 2.5,
          //           height: 100,
          //           // width: SizeConfig.screenWidth / 2,
          //           // width: SizeConfig.finalWidth,
          //           child: Stack(
          //             children: [
          //               Transform.rotate(angle: 75, child: MiscBLMImageDisplayTemplate(),),

          //               // Positioned(left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),
          //               Positioned(left: SizeConfig.screenWidth / 3, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

          //               Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

          //               Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

          //               Positioned(top: SizeConfig.blockSizeHorizontal * 25, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

          //               Positioned(top: SizeConfig.blockSizeHorizontal * 25, right: 0, child: MiscBLMImageDisplayTemplate(),),

          //               Positioned(bottom: 0, left: 0, child: Transform.rotate(angle: 0, child: MiscBLMImageDisplayTemplate(),),),

          //               Positioned(bottom: 0, left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

          //               Positioned(right: 10, bottom: 0, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

          //               Center(child: Image.asset('assets/icons/logo.png', height: 150, width: 150,),),
                        
          //             ],
          //           ),
          //         ),

          //         // SizedBox(height: ScreenUtil().setHeight(25)),
          //         SizedBox(height: 25,),

          //         Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

          //         SizedBox(height: SizeConfig.blockSizeVertical * 5,),
              
          //         MiscBLMButtonTemplate(
          //           buttonText: 'Join', 
          //           buttonTextStyle: TextStyle(
          //             // fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold, 
          //             color: Color(0xffffffff),
          //           ), 
          //           onPressed: (){
          //             Navigator.pushNamed(context, '/blm/login');
          //           }, 
          //           width: SizeConfig.screenWidth / 2, 
          //           // height: ScreenUtil().setHeight(45),
          //           height: 45,
          //           buttonColor: Color(0xff4EC9D4),
          //         ),

          //         // SizedBox(height: ScreenUtil().setHeight(10)),
          //         SizedBox(height: 80,),

          //       ],
          //     ),
          //     ),
              
          //   ],
          // ),
        ),
      ),
    );
  }
}











// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// // import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:flutter/material.dart';
// // import 'package:responsive_framework/responsive_framework.dart';

// class BLMJoin extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       // body: ResponsiveWrapper(
//       //   maxWidth: SizeConfig.screenWidth,
//       //   defaultScale: true,
//       //   breakpoints: [
//       //     ResponsiveBreakpoint.resize(480, name: MOBILE),
//       //     ResponsiveBreakpoint.autoScale(800, name: TABLET),
//       //     ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//       //     ResponsiveBreakpoint.autoScale(2460, name: '4K'),
//       //   ],
//       //   child: Container(
//       //     height: SizeConfig.screenHeight,
//       //     child: Center(),
//       //   ),
//       // ),
//       body: LayoutBuilder( 
//         builder: (context, constraints) {
//           return OrientationBuilder(
//             builder: (context, orientation) {
//               //initialize SizerUtil()
//               SizerUtil().init(constraints, orientation); 
//               // return Container(
//               //   color: Colors.red,
//               //   child: Center(
//               //     // child: Text('Nice!'),
//               //     child: Container(
//               //       width: 80.0.w,
//               //       height: 30.0.h,
//               //       // width: 20,
//               //       // height: 30,
//               //       color: Colors.blue,
//               //     ),
//               //   ),
//               // );
//               return Stack(
//                 children: [

//                   MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

//                   Padding(
//                     padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                     child: Column(
//                     children: [

//                       // SizedBox(height: ScreenUtil().setHeight(10)),
//                       // SizedBox(height: 10),
//                       // SizedBox(height: 30),
//                       SizedBox(height: 1.0.h,),

//                       Align(
//                         alignment: Alignment.centerLeft, 
//                         child: IconButton(
//                           onPressed: (){
//                             Navigator.pop(context);
//                           }, 
//                           icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: 30),
//                         ),
//                       ),

//                       // SizedBox(height: ScreenUtil().setHeight(10)),
//                       // SizedBox(height: 10),
//                       SizedBox(height: 1.0.h,),

//                       Container(
//                         // height: ScreenUtil().setHeight(45),
//                         // height: 340,
//                         color: Colors.blue,
//                         // height: 45,
//                         width: 80.0.w,
//                         height: 5.0.h,
//                         // height: 100,
//                         // constraints: BoxConstraints.loose(),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Center(
//                                 child: Text('BLACK',
//                                   style: TextStyle(
//                                     // fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xff000000),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 child: Text('LIVES',
//                                   style: TextStyle(
//                                     // fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xffffffff),
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xff000000),
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Center(
//                                 child: Text('MATTER',
//                                   style: TextStyle(
//                                     // fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xff000000),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // SizedBox(height: ScreenUtil().setHeight(50)),
//                       // SizedBox(height: 50,),

//                       SizedBox(
//                         height: SizerUtil.orientation == Orientation.portrait
//                         ? 20.0.h
//                         : 12.0.h,
//                       ),

//                       // ContainerResponsive(
//                       //   width: SizeConfig.screenWidth,
//                       //   height: SizeConfig.screenHeight / 2,
//                       //   heightResponsive: false,
//                       //   widthResponsive: true,
//                       //   child: 
//                       // ),
//                       Container(
//                         color: Colors.red,
//                         // height: SizeConfig.screenHeight / 2,
//                         // height: SizeConfig.screenHeight / 2.5,
//                         // height: 100,
//                         width: 80.0.w,
//                         height: 30.0.h,
//                         // height: SizerUtil.orientation == Orientation.portrait
//                         // ? 20.0.h
//                         // : 12.0.h,
//                         // width: SizeConfig.screenWidth / 2,
//                         // width: SizeConfig.finalWidth,
//                         child: Stack(
//                           children: [
//                             Transform.rotate(angle: 75, child: MiscBLMImageDisplayTemplate(),),

//                             // Positioned(left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),
//                             Positioned(left: SizeConfig.screenWidth / 3, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                             Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                             Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                             Positioned(top: SizeConfig.blockSizeHorizontal * 25, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                             Positioned(top: SizeConfig.blockSizeHorizontal * 25, right: 0, child: MiscBLMImageDisplayTemplate(),),

//                             Positioned(bottom: 0, left: 0, child: Transform.rotate(angle: 0, child: MiscBLMImageDisplayTemplate(),),),

//                             Positioned(bottom: 0, left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                             Positioned(right: 10, bottom: 0, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

//                             Center(child: Image.asset('assets/icons/logo.png', height: 150, width: 150,),),
                            
//                           ],
//                         ),
//                       ),

//                       // SizedBox(height: ScreenUtil().setHeight(25)),
//                       SizedBox(height: 25,),

//                       Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                  
//                       MiscBLMButtonTemplate(
//                         buttonText: 'Join', 
//                         buttonTextStyle: TextStyle(
//                           // fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, 
//                           color: Color(0xffffffff),
//                         ), 
//                         onPressed: (){
//                           Navigator.pushNamed(context, '/blm/login');
//                         }, 
//                         width: SizeConfig.screenWidth / 2, 
//                         // height: ScreenUtil().setHeight(45),
//                         height: 45,
//                         buttonColor: Color(0xff4EC9D4),
//                       ),

//                       // SizedBox(height: ScreenUtil().setHeight(10)),
//                       SizedBox(height: 80,),

//                     ],
//                   ),
//                   ),
                  
//                 ],
//               );
//             },
//           );
//         }
//       ),
//     );
//   }
// }