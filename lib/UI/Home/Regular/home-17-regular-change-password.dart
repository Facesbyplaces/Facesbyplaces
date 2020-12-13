// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';

// class HomeRegularUserChangePassword extends StatelessWidget{

//   final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
//   final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         return Navigator.canPop(context);
//       },
//       child: GestureDetector(
//         onTap: (){
//           FocusNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Change password', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
//             centerTitle: true,
//             leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//             backgroundColor: Color(0xff04ECFF),
//           ),
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Container(
//               padding: EdgeInsets.all(20.0),
//               height: SizeConfig.screenHeight,
//               child: Column(
//                 children: [

//                   MiscRegularInputFieldTemplate(key: _key1, labelText: 'Current Password', obscureText: true,),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   MiscRegularInputFieldTemplate(key: _key2, labelText: 'New Password', obscureText: true,),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Expanded(child: Container(),),

//                   MiscRegularButtonTemplate(
//                     buttonText: 'Update',
//                     buttonTextStyle: TextStyle(
//                       fontSize: SizeConfig.safeBlockHorizontal * 4, 
//                       fontWeight: FontWeight.bold, 
//                       color: Color(0xffffffff),
//                     ),
//                     onPressed: (){
//                       Navigator.popAndPushNamed(context, 'home/regular/home-15-regular-user-details');
//                     }, 
//                     width: SizeConfig.screenWidth / 2, 
//                     height: SizeConfig.blockSizeVertical * 7, 
//                     buttonColor: Color(0xff04ECFF),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 20,),

//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }