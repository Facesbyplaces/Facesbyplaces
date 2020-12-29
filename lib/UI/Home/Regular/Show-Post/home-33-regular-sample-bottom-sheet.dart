// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';



// class BottomSheetWidget extends StatefulWidget {
//   @override
//   _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
// }
// class _BottomSheetWidgetState extends State<BottomSheetWidget> {
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       body: Container(
//         color: Colors.red,
//         child: Column(
//           children: [
//             Container(
//               height: SizeConfig.blockSizeVertical * 5,
//               padding: EdgeInsets.only(left: 10.0, right: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [

//                   GestureDetector(
//                     onTap: () async{
                      
//                     },
//                     child: Row(
//                       children: [
//                         Icon(Icons.favorite_border_outlined, color: Color(0xff000000),),

//                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                         Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                       ],
//                     ),
//                   ),

//                   SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                   GestureDetector(
//                     onTap: (){
                      
//                     },
//                     child: Row(
//                       children: [
//                         Icon(Icons.chat_bubble_outline_outlined, color: Color(0xff000000),),

//                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                         Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: Container(
//       margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
//       height: 160,
//       child: Column(
//         // mainAxisSize: MainAxisSize.max,
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [

//           Container(
//             height: 125,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               boxShadow: [
//                 BoxShadow(blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
//                 ],
//               ),
//             child: Column(
//               children: [

//                 DecoratedTextField(),
//                 SheetButton(),

//               ],
//             ),
//           ),

//         ],
//       ),
//     ),
//     );
//   }
// }

// class DecoratedTextField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 50,
//         alignment: Alignment.center,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//             color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
//         child: TextField(
//           decoration: InputDecoration.collapsed(
//             hintText: 'Enter your reference number',
//           ),
//         ));
//   }
// }

// class SheetButton extends StatefulWidget {
//   _SheetButtonState createState() => _SheetButtonState();
// }
// class _SheetButtonState extends State<SheetButton> {
//   bool checkingFlight = false;
//   bool success = false;
//   @override
//   Widget build(BuildContext context) {
//     return !checkingFlight
//         ? MaterialButton(
//             color: Colors.grey[800],
//             onPressed: () {
//             },
//             child: Text(
//               'Check Flight',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         : !success
//             ? CircularProgressIndicator()
//             : Icon(
//                 Icons.check,
//                 color: Colors.green,
//               );
//   }
// }