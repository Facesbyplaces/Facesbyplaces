// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-05-bloc-regular-misc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class MiscRegularUserProfileDraggableTabsList extends StatelessWidget{

//   final int index;
//   final int tab;

//   MiscRegularUserProfileDraggableTabsList({this.index, this.tab});

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return BlocProvider(
//       create: (BuildContext context) => BlocMiscRegularJoinMemorialButton(),
//       child: BlocBuilder<BlocMiscRegularJoinMemorialButton, bool>(
//         builder: (context, joinButton){
//           return GestureDetector(
//             onTap: (){},
//             child: Container(
//               height: SizeConfig.blockSizeVertical * 15,
//               color: Color(0xffffffff),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CircleAvatar(
//                       maxRadius: SizeConfig.blockSizeVertical * 5,
//                       backgroundImage: AssetImage('assets/icons/profile2.png'),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Text('Memorial',
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff000000),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Text('Memorial',
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                 fontWeight: FontWeight.w200,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(right: 15.0),
//                       child: ((){
//                         return MaterialButton(
//                           elevation: 0,
//                           padding: EdgeInsets.zero,

//                           textColor: ((){
//                             if(joinButton == true){
//                               return Color(0xffffffff);
//                             }else{
//                               return Color(0xff4EC9D4);
//                             }
//                           }()),
//                           splashColor: Color(0xff4EC9D4),
//                           onPressed: (){
//                             context.read<BlocMiscRegularJoinMemorialButton>().modify(!joinButton);
//                           },
//                           child: ((){
//                             if(joinButton == true){
//                               return Text('Leave',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                 ),
//                               );
//                             }else{
//                               return Text('Join',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                 ),
//                               );
//                             }
//                           }()),
//                           height: SizeConfig.blockSizeVertical * 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                             side: ((){
//                               if(joinButton == true){
//                                 return BorderSide(color: Color(0xff04ECFF));
//                               }else{
//                                 return BorderSide(color: Color(0xff4EC9D4));
//                               }
//                             }())
//                           ),
//                           color: ((){
//                             if(joinButton == true){
//                               return Color(0xff04ECFF);
//                             }else{
//                               return Color(0xffffffff);
//                             }
//                           }()),
//                         );  

//                       }()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
