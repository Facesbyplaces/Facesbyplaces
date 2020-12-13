// // import 'package:facesbyplaces/API/BLM/api-24-blm-hide-family-setting.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-extra.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-16-regular-setting-detail.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';

// // class HomeRegularMemorialSettingsPrivacy extends StatelessWidget{

// class HomeRegularMemorialSettingsPrivacy extends StatefulWidget{

//   HomeRegularMemorialSettingsPrivacyState createState() => HomeRegularMemorialSettingsPrivacyState();
// }

// class HomeRegularMemorialSettingsPrivacyState extends State<HomeRegularMemorialSettingsPrivacy>{

//   // bool family = false;

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return ListView(
//       physics: ClampingScrollPhysics(),
//       children: [

//         MiscRegularSettingDetailTemplate(
//           onTap: (){

//           }, 
//           titleDetail: 'Customize shown info', 
//           contentDetail: 'Customize what others see on your page',
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         Container(
//           height: SizeConfig.blockSizeVertical * 10,
//           color: Color(0xffffffff),
//           child: Row(
//             children: [
//               Expanded(
//                 child: MiscRegularSettingDetailTemplate(
//                   onTap: (){

//                   }, 
//                   titleDetail: 'Hide Family', 
//                   contentDetail: 'Show or hide family details',
//                 ),
//               ),
//               MiscRegularToggleSwitchTemplate(),
              
//             ],
//           ),
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         Container(
//           height: SizeConfig.blockSizeVertical * 10,
//           color: Color(0xffffffff),
//           child: Row(
//             children: [
//               Expanded(
//                 child: MiscRegularSettingDetailTemplate(
//                   onTap: (){

//                   }, 
//                   titleDetail: 'Hide Friends', 
//                   contentDetail: 'Show or hide friends details',
//                 ),
//               ),
//               MiscRegularToggleSwitchTemplate(),
//             ],
//           ),
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         Container(
//           height: SizeConfig.blockSizeVertical * 10,
//           color: Color(0xffffffff),
//           child: Row(
//             children: [
//               Expanded(
//                 child: MiscRegularSettingDetailTemplate(
//                   onTap: (){

//                   }, 
//                   titleDetail: 'Hide Followers', 
//                   contentDetail: 'Show or hide your followers',
//                 ),
//               ),
//               MiscRegularToggleSwitchTemplate(),
//             ],
//           ),
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//         Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

//         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//       ],
//     );
//   }
// }