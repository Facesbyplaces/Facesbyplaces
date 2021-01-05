// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/material.dart';

// class MiscBLMShowReply extends StatefulWidget{
//   final int currentUserId;
//   final int userId;
//   final String image;
//   final String firstName;
//   final String lastName;
//   final String commentBody;
//   final String createdAt;
//   final int numberOfLikes;
//   final int index;

//   MiscBLMShowReply({this.currentUserId, this.userId, this.image, this.firstName, this.lastName, this.commentBody, this.createdAt, this.numberOfLikes, this.index});

//   MiscBLMShowReplyState createState() => MiscBLMShowReplyState(currentUserId: currentUserId, userId: userId, image: image, firstName: firstName, lastName: lastName, commentBody: commentBody, createdAt: createdAt, numberOfLikes: numberOfLikes, index: index);
// }


// class MiscBLMShowReplyState extends State<MiscBLMShowReply>{

//   final int currentUserId;
//   final int userId;
//   final String image;
//   final String firstName;
//   final String lastName;
//   final String commentBody;
//   final String createdAt;
//   final int numberOfLikes;
//   final int index;

//   MiscBLMShowReplyState({this.currentUserId, this.userId, this.image, this.firstName, this.lastName, this.commentBody, this.createdAt, this.numberOfLikes, this.index});

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return Column(
//       children: [
//         Container(
//           height: SizeConfig.blockSizeVertical * 5,
//           child: Row(
//             children: [
//               SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

//               CircleAvatar(
//                 backgroundImage: image != null ? NetworkImage(image) : AssetImage('assets/icons/app-icon.png'),
//                 backgroundColor: Color(0xff888888),
//               ),

//               SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//               userId == currentUserId
//               ? Expanded(
//                 child: Text('You',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//               : Expanded(
//                 child: Text(firstName + ' ' + lastName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

//               SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//               Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//             ],
//           ),
//         ),

//         Row(
//           children: [
//             SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(10.0),
//                 child: Text(
//                   commentBody,
//                   style: TextStyle(
//                     color: Color(0xffffffff),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   color: Color(0xff4EC9D4),
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//         Row(
//           children: [

//             SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

//             // Text(convertDate(createdAt)),
//             Text(timeago.format(DateTime.parse(createdAt))),

//             SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//             GestureDetector(
//               onTap: (){
                
//               },
//               child: Text('Reply',),
//             ),

//           ],
//         ),

//         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//       ],
//     );
//   }
// }

