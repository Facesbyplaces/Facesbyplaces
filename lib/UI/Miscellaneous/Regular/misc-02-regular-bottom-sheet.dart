// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';

// class MiscRegularBottomSheetComment extends StatefulWidget{
//   MiscRegularBottomSheetComment({Key key}) : super(key: key);

//   MiscRegularBottomSheetCommentState createState() => MiscRegularBottomSheetCommentState();
// }

// class MiscRegularBottomSheetCommentState extends State<MiscRegularBottomSheetComment>{

//   TextEditingController controller;

//   void initState(){
//     super.initState();
//     controller = TextEditingController(text: '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Row(
//       children: [

//         CircleAvatar(backgroundColor: Color(0xff888888),),

//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.all(10.0),
//             child: TextFormField(
//               controller: controller,
//               cursorColor: Color(0xff000000),
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 fillColor: Color(0xffBDC3C7),
//                 filled: true,
//                 labelText: 'Say something...',
//                 labelStyle: TextStyle(
//                   fontSize: SizeConfig.safeBlockHorizontal * 4, 
//                   color: Color(0xffffffff),
//                 ),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xffBDC3C7),
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xffBDC3C7),
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         Container(
//           child: Text('Post',
//             style: TextStyle(
//               fontSize: SizeConfig.safeBlockHorizontal * 4,
//               fontWeight: FontWeight.bold, 
//               color: Color(0xff000000),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }