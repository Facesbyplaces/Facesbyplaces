// import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-02-show-user-posts.dart';
// import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-03-show-user-memorials.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'misc-04-blm-manage-memorial.dart';
// import 'misc-05-blm-post.dart';
// import 'misc-14-blm-empty-display.dart';
// import 'package:flutter/material.dart';

// class MiscBLMUserProfileDraggableSwitchTabs extends StatefulWidget {
//   final int userId;
//   MiscBLMUserProfileDraggableSwitchTabs({this.userId});

//   @override
//   MiscBLMUserProfileDraggableSwitchTabsState createState() => MiscBLMUserProfileDraggableSwitchTabsState(userId: userId);
// }

// class MiscBLMUserProfileDraggableSwitchTabsState extends State<MiscBLMUserProfileDraggableSwitchTabs> {
//   final int userId;
//   MiscBLMUserProfileDraggableSwitchTabsState({this.userId});

//   double height;
//   Offset position;
//   int currentIndex = 0;
//   List<Widget> children;

//   @override
//   void initState(){
//     super.initState();
//     height = SizeConfig.screenHeight;
//     position = Offset(0.0, height - 100);
//     children = [MiscBLMDraggablePost(userId: userId,), MiscBLMDraggableMemorials(userId: userId,)];
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Positioned(
//       left: position.dx,
//       top: position.dy - SizeConfig.blockSizeVertical * 10,
//       child: Draggable(
//         feedback: draggable(),
//         onDraggableCanceled: (Velocity velocity, Offset offset){
//           if(offset.dy > 100 && offset.dy < (SizeConfig.screenHeight - 100)){
//             setState(() {
//               position = offset;
//             });
//           }
//         },
//         child: draggable(),
//         childWhenDragging: Container(),
//         axis: Axis.vertical,
//       ),
//     );
//   }

//   draggable(){
//     return Material(
//       child: Container(
//         width: SizeConfig.screenWidth,
//         decoration: BoxDecoration(
//           color: Color(0xffffffff),
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Color(0xffaaaaaa),
//               offset: Offset(0, 0),
//               blurRadius: 5.0
//             ),
//           ],
//         ),
//         child: Column(
//           children: [

//             Container(
//               alignment: Alignment.center,
//               width: SizeConfig.screenWidth,
//               height: SizeConfig.blockSizeVertical * 8,
//               child: DefaultTabController(
//                 length: 2,
//                 initialIndex: currentIndex,
//                 child: TabBar(
//                   isScrollable: false,
//                   labelColor: Color(0xff04ECFF),
//                   unselectedLabelColor: Color(0xffCDEAEC),
//                   indicatorColor: Color(0xff04ECFF),
//                   onTap: (int number){
//                     setState(() {
//                       currentIndex = number;
//                     });
//                   },
//                   tabs: [

//                     Container(
//                       width: SizeConfig.screenWidth / 2.5,
//                       child: Center(
//                         child: Text('Post',
//                           style: TextStyle(
//                             fontSize: SizeConfig.safeBlockHorizontal * 4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ),

//                     Container(
//                       width: SizeConfig.screenWidth / 2.5,
//                       child: Center(
//                         child: Text('Memorials',
//                           style: TextStyle(
//                             fontSize: SizeConfig.safeBlockHorizontal * 4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ),

//                   ],
//                 ),
//               ),
//             ),

//             Container(
//               width: SizeConfig.screenWidth,
//               height: (SizeConfig.screenHeight - position.dy),
//               child: IndexedStack(
//                 index: currentIndex,
//                 children: children,
//               ),
//             ),

//             SizedBox(height: SizeConfig.blockSizeVertical * 10,),
            
//           ],
//         ),
//       ),
//     );
//   }
// }